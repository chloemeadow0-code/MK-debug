#!/usr/bin/env bash

set -Eeuo pipefail

# Builds the GPL/LGPL native runtime distributed with Mikeko. This file only
# orchestrates the separately licensed sources recorded in THIRD_PARTY_NOTICES.md.

readonly PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
readonly TARGET_TRIPLE="aarch64-linux-android26"
readonly TARGET_ABI="arm64-v8a"
readonly BUILD_ROOT="$PROJECT_ROOT/.build-proot/mikeko-native"
readonly PROOT_SOURCE="$PROJECT_ROOT/thirdparty/proot/src"
readonly TALLOC_SOURCE="$PROJECT_ROOT/thirdparty/talloc"
readonly POSIX_LOADER_AWK="$PROJECT_ROOT/scripts/proot-loader-info-posix.awk"
readonly NATIVE_DESTINATION="$PROJECT_ROOT/app/src/main/jniLibs/$TARGET_ABI"
readonly STATE_FILE="$BUILD_ROOT/input-state.sha256"

force_build=false

fail() {
    printf 'build-proot: %s\n' "$*" >&2
    exit 1
}

usage() {
    printf 'Usage: %s [--force]\n' "${0##*/}"
}

while (($#)); do
    case "$1" in
        --force) force_build=true ;;
        --help|-h) usage; exit 0 ;;
        *) usage >&2; fail "unknown option: $1" ;;
    esac
    shift
done

select_ndk() {
    if [[ -n "${ANDROID_NDK_HOME:-}" && -d "$ANDROID_NDK_HOME" ]]; then
        printf '%s\n' "$ANDROID_NDK_HOME"
        return
    fi

    local sdk_root="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}"
    [[ -n "$sdk_root" && -d "$sdk_root/ndk" ]] ||
        fail 'set ANDROID_NDK_HOME, ANDROID_SDK_ROOT, or ANDROID_HOME'

    local candidate
    candidate="$(find "$sdk_root/ndk" -mindepth 1 -maxdepth 1 -type d -printf '%f\t%p\n' |
        sort -V | tail -n 1 | cut -f2-)"
    [[ -n "$candidate" ]] || fail "no NDK installation found under $sdk_root/ndk"
    printf '%s\n' "$candidate"
}

need_command() {
    command -v "$1" >/dev/null 2>&1 || fail "required command is unavailable: $1"
}

NDK_ROOT="$(select_ndk)"
readonly NDK_ROOT
readonly TOOLCHAIN="$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin"
readonly C_COMPILER="$TOOLCHAIN/$TARGET_TRIPLE-clang"
readonly ELF_STRIP="$TOOLCHAIN/llvm-strip"
readonly SYSROOT="$BUILD_ROOT/sysroot"
readonly PROOT_WORKTREE="$BUILD_ROOT/proot-source"
readonly PRODUCT_STAGING="$BUILD_ROOT/products"

[[ -x "$C_COMPILER" ]] || fail "Android compiler not found: $C_COMPILER"
[[ -x "$ELF_STRIP" ]] || fail "LLVM strip tool not found: $ELF_STRIP"
[[ -f "$PROOT_SOURCE/GNUmakefile" ]] || fail 'PRoot source checkout is incomplete'
[[ -f "$TALLOC_SOURCE/talloc.c" ]] || fail 'talloc source checkout is incomplete'
[[ -f "$POSIX_LOADER_AWK" ]] || fail 'portable loader symbol script is missing'

need_command find
need_command make
need_command sha256sum
need_command sort
need_command awk

export PATH="$TOOLCHAIN:$PATH"

if ! command -v readelf >/dev/null 2>&1; then
    [[ -x "$TOOLCHAIN/llvm-readelf" ]] || fail 'readelf or llvm-readelf is required'
    readonly TOOL_SHIMS="$BUILD_ROOT/tool-shims"
    mkdir -p "$TOOL_SHIMS"
    ln -sfn "$TOOLCHAIN/llvm-readelf" "$TOOL_SHIMS/readelf"
    export PATH="$TOOL_SHIMS:$PATH"
fi

calculate_input_state() {
    {
        printf '%s\0' "$NDK_ROOT" "$TARGET_TRIPLE"
        sha256sum "$POSIX_LOADER_AWK"
        while IFS= read -r -d '' source_file; do
            sha256sum "$source_file"
        done < <(find "$PROOT_SOURCE" "$TALLOC_SOURCE" -type f -print0 | sort -z)
    } | sha256sum | cut -d ' ' -f1
}

products_exist() {
    [[ -s "$NATIVE_DESTINATION/libproot_exec.so" &&
       -s "$NATIVE_DESTINATION/libproot_loader.so" &&
       -s "$NATIVE_DESTINATION/libtalloc.so" ]]
}

CURRENT_STATE="$(calculate_input_state)"
readonly CURRENT_STATE
if [[ "$force_build" == false && -f "$STATE_FILE" ]] && products_exist; then
    if [[ "$(<"$STATE_FILE")" == "$CURRENT_STATE" ]]; then
        printf 'Native runtime is already current.\n'
        exit 0
    fi
fi

mkdir -p "$BUILD_ROOT" "$SYSROOT/include" "$SYSROOT/lib" "$PRODUCT_STAGING" "$NATIVE_DESTINATION"

compile_talloc() {
    printf 'Compiling talloc for %s...\n' "$TARGET_ABI"
    (
        cd "$TALLOC_SOURCE"
        "$C_COMPILER" \
            -fPIC -O2 -shared \
            -Wl,-soname,libtalloc.so \
            -DHAVE_CONFIG_H -I. \
            talloc.c \
            -o "$PRODUCT_STAGING/libtalloc.unstripped.so"
    )
    install -m 0644 "$TALLOC_SOURCE/talloc.h" "$SYSROOT/include/talloc.h"
    install -m 0755 "$PRODUCT_STAGING/libtalloc.unstripped.so" "$SYSROOT/lib/libtalloc.so"
}

prepare_proot_sources() {
    case "$PROOT_WORKTREE" in
        "$BUILD_ROOT"/*) ;;
        *) fail "refusing to replace unexpected worktree: $PROOT_WORKTREE" ;;
    esac

    rm -rf -- "$PROOT_WORKTREE"
    mkdir -p "$PROOT_WORKTREE"
    cp -a "$PROOT_SOURCE/." "$PROOT_WORKTREE/"

    find "$PROOT_WORKTREE" -type f \
        \( -name '*.o' -o -name '*.d' -o -name '*.res' \) -delete
    rm -f -- \
        "$PROOT_WORKTREE/build.h" \
        "$PROOT_WORKTREE/proot" \
        "$PROOT_WORKTREE/loader/loader" \
        "$PROOT_WORKTREE/.check_process_vm" \
        "$PROOT_WORKTREE/.check_seccomp_filter"

    # Host-executed capability probes cannot run during Android cross-compilation.
    printf 'int main(void) { return 0; }\n' > "$PROOT_WORKTREE/.check_process_vm.c"
    printf 'int main(void) { return 0; }\n' > "$PROOT_WORKTREE/.check_seccomp_filter.c"

    install -m 0644 "$POSIX_LOADER_AWK" "$PROOT_WORKTREE/loader/loader-info.awk"

    local ashmem_source="$PROOT_WORKTREE/extension/ashmem_memfd/ashmem_memfd.c"
    if [[ -f "$ashmem_source" ]] && ! grep -Fq '#include <string.h>' "$ashmem_source"; then
        sed -i '1i#include <string.h>' "$ashmem_source"
    fi
}

compile_proot() {
    printf 'Compiling PRoot for %s...\n' "$TARGET_ABI"
    (
        cd "$PROOT_WORKTREE"
        export CC="$C_COMPILER"
        export CPPFLAGS="-I$SYSROOT/include -DSYS_SECCOMP=1"
        export LDFLAGS="-L$SYSROOT/lib"
        export SOURCE_DATE_EPOCH="${SOURCE_DATE_EPOCH:-0}"
        make \
            CROSS_COMPILE="$TARGET_TRIPLE-" \
            PROOT_UNBUNDLE_LOADER="mikeko-loader" \
            GIT=/bin/true \
            proot
    )

    [[ -s "$PROOT_WORKTREE/proot" ]] || fail 'PRoot executable was not produced'
    [[ -s "$PROOT_WORKTREE/loader/loader" ]] || fail 'PRoot loader was not produced'
}

publish_products() {
    "$ELF_STRIP" --strip-all -o "$PRODUCT_STAGING/libproot_exec.so" "$PROOT_WORKTREE/proot"
    "$ELF_STRIP" --strip-all -o "$PRODUCT_STAGING/libtalloc.so" "$SYSROOT/lib/libtalloc.so"
    install -m 0755 "$PROOT_WORKTREE/loader/loader" "$PRODUCT_STAGING/libproot_loader.so"

    for product in libproot_exec.so libproot_loader.so libtalloc.so; do
        install -m 0755 "$PRODUCT_STAGING/$product" "$NATIVE_DESTINATION/$product"
        printf 'Installed %-22s %s bytes\n' "$product" "$(stat -c '%s' "$NATIVE_DESTINATION/$product")"
    done
}

compile_talloc
prepare_proot_sources
compile_proot
publish_products
printf '%s\n' "$CURRENT_STATE" > "$STATE_FILE"
printf 'Native runtime build completed successfully.\n'
