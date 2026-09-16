# Release compliance checklist

Complete every blocking item before publishing an APK, AAB, source archive,
commercial download, or desktop installer (MSI/EXE).

## Copyright boundary

- [ ] Confirm every source file is either independently authored proprietary
      Mikeko code, or separately identified third-party code covered by its
      applicable license and provenance records. Any file already published
      under the repository's former project-wide MIT License must be listed
      as a legacy MIT-licensed file; previously published copies keep that
      grant regardless of later license changes. Do not assume that replacing
      the LICENSE retroactively eliminates any license rights that may
      already have arisen; a license change only sets the policy for future
      distributions and subsequent versions.
      As of 2026-09-12, no known public source distribution, public fork, or
      external source recipient has been identified. This record does not
      purport to revoke or alter any license rights that may previously have
      arisen.
- [ ] Review provenance records for every retained, imported, or adapted file.
- [ ] Preserve every copyright and license notice required by files included
      in the distribution.
- [ ] Do not describe third-party components as Mikeko originals.
- [ ] Verify icons, screenshots, fonts, audio, plugin assets, and marketing copy
      have written source and redistribution records.
- [x] Confirm the provenance of the 18 image assets flagged `PENDING` in
      `ASSET_PROVENANCE.csv` on 2026-09-15 (game-covers, diary weather icons,
      `mikeko_bg_kraft.webp`, `mikeko_bg_rouge.webp`) and complete their
      `creator` / `source` / `license` fields before the next public release.
      Confirmed 2026-09-15 by the project owner as original artwork by the
      Mikeko development team; CSV rows completed (see THIRD_PARTY_NOTICES.md).

## Native and root filesystem components

- [ ] Rebuild PRoot and talloc from the recorded source tree using
      `build-proot.sh`; record hashes of all three resulting `.so` files.
- [ ] Verify the PRoot source submodule is exactly
      `f38518d15b177e9818fb1a6b942937020c3bcc39`.
- [ ] Package the complete PRoot and talloc corresponding source, local patches,
      and `build-proot.sh` beside the binary download, or provide another GPLv2
      compliant source-delivery method.
- [ ] Include `licenses/PROOT-COPYING`, `licenses/LGPL-3.0.txt`, `NOTICE`, and
      `THIRD_PARTY_NOTICES.md` in the release materials.
- [ ] Verify the Alpine bundle SHA-256 remains
      `f31202c4070c4ef7de9e157e1bd01cb4da3a2150035d74ea5372c5e86f1efac1`.

## LaTeX, SSH, and desktop runtime

- [ ] Include `licenses/JLATEXMATH-ANDROID-LICENSE`, `licenses/GPL-2.0.txt`,
      `licenses/JSCH-LICENSE`, `licenses/BOUNCYCASTLE-LICENSE.txt`, and
      `licenses/GPL-2.0-WITH-CLASSPATH-EXCEPTION.txt` in the release
      materials.
- [ ] Keep the jlatexmath-android source revision recorded
      (tag `1.5`, commit `6c48090e729354f85bb47356ede9eeb97f7e5f78`) and
      provide library-source availability as required by its GPL-2.0 +
      Classpath exception terms. For Android APK/AAB releases, attach the
      jlatexmath-android source for tag `1.5` (or a written source offer for
      that exact tag) beside the binary, or include it in the
      `Mikeko-<version>-thirdparty-source.zip` bundle.
- [ ] Verify the fonts packaged inside the jlatexmath artifact keep their
      bundled license texts in the shipped binaries (OFL, Knuth License,
      public domain, free licenses, GPL-2.0 Greek fonts).
- [ ] Record and ship the Bouncy Castle notice (`licenses/BOUNCYCASTLE-LICENSE.txt`)
      with Android releases; the APK packaging stage may drop the
      `org/bouncycastle/LICENSE.class` notice embedded in bcprov 1.72.
- [ ] Record the JDK vendor, distribution, and version used by `jpackage` for
      the desktop installers; prefer an open build (e.g., Eclipse Temurin) and
      provide the GPL-2.0 + Classpath Exception source-availability reference.
      If an Oracle JDK is used, review Oracle's redistribution terms instead.
      Recorded 2026-09-14: release builds run on Eclipse Temurin
      21.0.12+8-LTS (the Gradle daemon JVM feeding `jpackage`);
      corresponding source: tag `jdk-21.0.12+8` in
      https://github.com/adoptium/jdk21u (commit
      `9aeb78a2b39c56356b792b7e5294377036ef0a19`). Re-record on every
      toolchain change.
- [ ] Confirm the Google Play SDK terms are satisfied for
      `play-services-location` on the chosen distribution channel.
- [ ] Include the Skia license text and its third-party notices in the
      release materials: skiko 0.150.1 (`skiko-awt`,
      `skiko-awt-runtime-windows-x64`) bundles no license/legal/notice
      files (verified 2026-09-14 — the runtime jar contains only the native
      DLL, its SHA-256 file, and `icudtl.dat`). Mirrored already:
      `licenses/SKIKO-LICENSE` (Apache-2.0), `licenses/SKIKO-NOTICE`
      (AOSP-derived code), `licenses/SKIA-LICENSE` (BSD-style). The
      remaining Skia per-dependency third-party notices must come from the
      Skia tree matching the skiko build.
- [ ] Ship the notices that dependency jars may drop during the desktop
      ProGuard/packaging stage: MCP Kotlin SDK 0.14.0 (MIT, per artifact
      POM; `licenses/MCP-KOTLIN-SDK-LICENSE`), slf4j-api 2.0.17 (MIT;
      `licenses/SLF4J-LICENSE.txt`), and the sqlite-jdbc zentus notice
      (`licenses/SQLITE-JDBC-LICENSE.zentus`). sqlite-jdbc's bundled
      META-INF notice was observed dropped at the ProGuard stage
      (2026-09-14).

## Copyleft source-delivery obligations

Components in the current distribution that trigger source or relink obligations,
and the fulfillment method chosen for each. Re-derive the method from the
component's actual LICENSE at every dependency or version bump; do not assume
the method recorded here still applies.

- PRoot (GPL-2.0-or-later; `libproot_exec.so`, `libproot_loader.so`) and
  talloc (LGPL-3.0-or-later; `libtalloc.so`): attach
  `Mikeko-<version>-thirdparty-source.zip` to every public distribution (each
  APK release and each desktop installer release) containing
  - the `thirdparty/proot` tree at the exact recorded revision, including all
    local modifications,
  - the `thirdparty/talloc` 2.4.2 sources exactly as vendored,
  - `build-proot.sh` and any local build changes,
  - `licenses/PROOT-COPYING`, `licenses/LGPL-3.0.txt`, `licenses/GPL-2.0.txt`,
  - a README pointing to `THIRD_PARTY_NOTICES.md`.

  The intended compliance method is to accompany the distributed binaries
  with the complete corresponding source and the rebuild/relink materials
  required by the applicable GPL/LGPL versions — for talloc, the linking
  application is PRoot, never Mikeko. Verify the zip contents against the
  exact vendored LICENSE before every release: whether they constitute
  complete corresponding source depends on how the shipped binaries were
  actually built, not on the zip name. Mikeko application sources are not
  part of these obligations.

- Alpine minirootfs (`app/src/main/assets/sandbox/alpine-rootfs.bundle`):
  inventory EVERY package actually contained in the bundle — record package
  name, version, license, and source package — and fulfill the source
  obligations of every package whose license requires it. BusyBox and
  apk-tools are known examples, not an exhaustive list. Re-run the inventory
  whenever the base image is bumped, or slim the rootfs to remove copyleft
  packages.

- jlatexmath-android: verify the exact tag/artifact LICENSE and any
  applicable linking exception before release. Do not assume a Classpath
  exception applies globally unless the distributed version expressly grants
  it. Verified 2026-09-12 against tag `1.5` (commit
  `6c48090e729354f85bb47356ede9eeb97f7e5f78`): the repository LICENSE is
  GPL-2.0-or-later and contains, in full, the special linking exception
  (link with independent modules, distribute the resulting executable under
  terms of your choice); the exception is granted in the library's own
  LICENSE covering the library as a whole. Attach the upstream library
  source for the same tag — this also covers the GPL-2.0 Greek fonts bundled
  inside the font artifact. Re-verify on every upgrade.

- Bundled JRE (jpackage), OpenJFX jars, and desugar_jdk_libs: determine the
  source-delivery method from the exact distributed version and its license
  at release time. Prefer accompanying the exact Corresponding Source or an
  equivalent compliant source-delivery method. Do not assume a previously
  recorded GPLv2 §3(b) method remains valid after upgrades. Note that both
  OpenJFX and desugar_jdk_libs grant the Classpath exception only to files
  expressly designated in their LICENSE/NOTICE files — verify the actual
  files and exception text, never infer from the project name.
  Current-version references recorded 2026-09-14: OpenJFX 21.0.8 — tag
  `21.0.8+2` in https://github.com/openjdk/jfx21u; jpackage JRE — Eclipse
  Temurin 21.0.12+8-LTS, tag `jdk-21.0.12+8` in
  https://github.com/adoptium/jdk21u. Re-pin both on every bump.
  For Android releases, desugar_jdk_libs 2.1.5 (GPL-2.0 + Classpath
  Exception, per the artifact POM verified 2026-09-15) is applied at build
  time via `coreLibraryDesugaring`; record the corresponding source
  reference `https://github.com/google/desugar_jdk_libs` at tag/release
  matching 2.1.5 in the release record and ship the source reference (and
  the license text `licenses/GPL-2.0-WITH-CLASSPATH-EXCEPTION.txt`) with
  the Android release materials. Re-pin on every version bump.

- OpenJFX platform-specific artifacts (the six `21.0.8:win` jars): verified
  2026-09-12 that none of them bundles any license/legal/notice files. Before
  release, unpack the exact distributed jars and inventory embedded
  third-party/native components — `javafx-web` embeds a WebKit build whose
  sources are largely LGPL-2.1, `javafx-media` links platform media
  frameworks — and preserve their notices from the matching OpenJFX source
  tag. The Maven-level GPLv2+Classpath-Exception declaration covers the
  JavaFX module code only; it does not replace the licenses of embedded
  third-party code.

## Gradle dependencies

- [ ] Resolve `releaseRuntimeClasspath` (`:app`) and the desktop runtime
      classpath (`:desktop`) from a clean environment.
- [ ] Export every direct and transitive component, version, license, copyright
      notice, and source URL.
- [ ] Review dependencies with missing, custom, copyleft, or conflicting terms.
- [ ] Include all required dependency notices with the application or release.

- 2026-09-14 desktop runtime audit: `:desktop` runtime classpath resolved
  via `resolvedArtifacts` (101 third-party artifacts + 3 first-party
  modules): 91 Apache-2.0; MCP Kotlin SDK client/core 0.14.0 MIT (per
  artifact POMs); slf4j-api 2.0.17 MIT (per jar text); jsch 0.2.23
  BSD-style + ISC; OpenJFX six `21.0.8:win` jars GPL-2.0+CE (their POMs
  declare no license at all — the project LICENSE is authoritative). No
  AGPL, SSPL, or exception-less GPL component present. Re-run on every
  dependency change before release.

- 2026-09-15 Android runtime audit: `:app` `releaseRuntimeClasspath`
  resolved and cross-checked against artifact POMs/in-JAR license texts.
  Direct + transitive components: AndroidX/Kotlin/Compose/Ktor/OkHttp/Okio/
  Coil/Haze/QuickJS-KT/pdfbox-android/kotlinx — Apache-2.0; jlatexmath
  1.5 — GPL-2.0+CE; jsch 0.2.23 — BSD + ISC; MCP Kotlin SDK 0.14.0 — MIT;
  slf4j-api 2.0.17 — MIT; Bouncy Castle 1.72 — Bouncy Castle Licence;
  kotlin-logging 8.0.4, typesafe config 1.4.5, jansi 2.4.2,
  accompanist-drawablepainter 0.32.0, guava 33.3.1-android, jspecify 1.0.0 —
  Apache-2.0; desugar_jdk_libs 2.1.5 — GPL-2.0+CE (build-time);
  desugar_jdk_libs_configuration 2.1.5 — BSD-3-Clause (build-time);
  play-services-location/base/basement/tasks — Android Software Development
  Kit License (proprietary). No AGPL, SSPL, or exception-less GPL component
  present. Re-run on every dependency change before release.

## Security and release hygiene

- [ ] Confirm no API keys, tokens, `local.properties`, signing configuration,
      keystores, logs, or private endpoint URLs are committed or packaged.
- [ ] Build and test the release variant, including minification.
- [ ] Inspect the final APK/AAB contents and compare them with the notice list.
- [ ] Preserve the Git commit and source archive used for the exact release.

## Commercial use

Based on the licenses currently verified, commercial distribution is not
categorically prohibited, provided all applicable license obligations and
third-party terms are satisfied (for example the Google Play SDK terms for
`play-services-location`, or a JDK vendor's redistribution terms for the
bundled runtime). Commercial use does not waive attribution, license-text,
corresponding-source, relinking, or other license obligations. This checklist
is an engineering compliance aid, not a substitute for advice from qualified
counsel for a disputed or high-risk release.
