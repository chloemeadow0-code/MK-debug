# Third-party notices

This file records the direct third-party components distributed by or linked
into Mikeko, including the Android app and the desktop installers. Transitive
Gradle dependencies must be regenerated and reviewed before each public
release; see `RELEASE_COMPLIANCE.md`.

## Native runtime components

### PRoot for Termux

- Files: `libproot_exec.so`, `libproot_loader.so`
- Source: https://github.com/termux/proot
- Exact source revision: `f38518d15b177e9818fb1a6b942937020c3bcc39`
- Source location: `thirdparty/proot`
- License: GNU General Public License version 2 or later
- License text: `licenses/PROOT-COPYING`
- Copyright: STMicroelectronics and PRoot contributors

The shipped binaries are built from the stated source revision by
`build-proot.sh`. A public binary release must include or provide equivalent
access to the complete corresponding source, including the build script and
local build changes. An upstream URL alone is not a substitute for the source
delivery required by the GPL.

### talloc 2.4.2

- File: `libtalloc.so`
- Source location: `thirdparty/talloc`
- Version: 2.4.2 (`TALLOC_BUILD_VERSION_MAJOR=2`, minor `4`, release `2`)
- Build script: `build-proot.sh`
- License: GNU Lesser General Public License version 3 or later
- License text: `licenses/LGPL-3.0.txt`
- Copyright: Andrew Tridgell, Stefan Metzmacher, and contributors

PRoot dynamically depends on this shared library. A public binary release must
provide the corresponding talloc source and local build files, preserve the
LGPL notice, and must not prevent replacement or reverse engineering solely for
debugging modifications to this LGPL library.

### Alpine Linux minirootfs

- Artifact: Alpine 3.21.0 aarch64 minirootfs
- File: `app/src/main/assets/sandbox/alpine-rootfs.bundle`
- Original URL: https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/aarch64/alpine-minirootfs-3.21.0-aarch64.tar.gz
- SHA-256: `f31202c4070c4ef7de9e157e1bd01cb4da3a2150035d74ea5372c5e86f1efac1`

Packages inside the root filesystem retain their respective copyright notices
and licenses. The root filesystem is not covered by Mikeko's
proprietary license.

## LaTeX rendering

### jlatexmath-android (rikkahub fork of JLaTeXMath)

- Component: `com.github.rikkahub:jlatexmath-android:1.5` (built by JitPack)
- Source: https://github.com/rikkahub/jlatexmath-android
- Exact source revision: tag `1.5`, commit
  `6c48090e729354f85bb47356ede9eeb97f7e5f78`
- License: GNU General Public License, version 2 or later, with the Classpath
  exception stated in the library's own LICENSE
- License text: `licenses/JLATEXMATH-ANDROID-LICENSE` (GPL text at
  `licenses/GPL-2.0.txt`)
- Copyright: DENIZET Calixte and JLaTeXMath/JMathTeX contributors; Android
  port by the rikkahub project

The Classpath exception permits linking the library and distributing the
combined application without placing Mikeko's own code under the GPL,
provided the library's own terms are met: keep the library's copyright,
license, and exception notices with the distribution, and keep the library
source available. The artifact also bundles fonts under their own terms
(OFL, Knuth License, public domain, free licenses, and GNU GPL version 2 for
the Greek fonts); the library LICENSE enumerates them and upstream ships
their license texts inside the artifact. These fonts and the library are not
covered by Mikeko's proprietary license.

## SSH transport

### jsch (mwiede fork of JSch)

- Component: `com.github.mwiede:jsch:0.2.23` (Android app and shared/desktop
  modules)
- Source: https://github.com/mwiede/jsch
- License: BSD-style license (see the upstream note in the license file; older
  0.0.* releases were LGPL, current releases are BSD-style)
- License text: `licenses/JSCH-LICENSE`, which also mirrors the vendored
  `LICENSE.JZlib.txt` and `LICENSE.jBCrypt.txt`
- Copyright: Atsuhiko Yamanaka, JCraft, Inc. (JSch); ymnk, JCraft, Inc.
  (JZlib); Damien Miller (jBCrypt); fork maintained by the mwiede project

Obligation: retain the copyright notice and disclaimer text in
distributions.

## MCP client

### MCP Kotlin SDK (client and core)

- Components: `io.modelcontextprotocol:kotlin-sdk-client-jvm` and
  `io.modelcontextprotocol:kotlin-sdk-core-jvm`, version 0.14.0
- Source: https://github.com/modelcontextprotocol/kotlin-sdk
- License: MIT — declared by the published 0.14.0 artifact POMs (both
  artifacts). The upstream repository is mid-transition from MIT to
  Apache-2.0; the LICENSE at tag `0.14.0`, mirrored at
  `licenses/MCP-KOTLIN-SDK-LICENSE`, describes that transition and remains
  the authoritative upstream text for this version.
- Obligation: retain the copyright/license notice in distributions via the
  release materials; no source delivery is required.

## Shader and visual effects

### liquidglass

- Source: https://github.com/ybouane/liquidglass
- License: MIT
- Copyright: ybouane
- Usage: AGSL edge-refraction shader in `LiquidGlassShader.kt` is adapted
  from the refraction, Fresnel, and chromatic aberration concepts implemented
  in this library.

## QR code rendering

### zxing core

- Component: `com.google.zxing:core:3.5.3`
- Source: https://github.com/zxing/zxing
- License: Apache License 2.0
- Copyright: ZXing authors
- Usage: Renders the WeChat Bot login QR code on screen
  (`WeixinBotScreen.kt`); local bitmap generation only, no camera/scanner
  components are used.

## PDFBox and Bouncy Castle (Android PDF rendering)

### pdfbox-android

- Component: `com.tom-roush:pdfbox-android:2.0.27.0` (Android app)
- Source: https://github.com/TomRoush/PdfBox-Android
- License: Apache-2.0 (declared by the artifact POM, verified 2026-09-15)
- Copyright: TomRoush and the Apache PDFBox project

### Bouncy Castle (transitive, pulled in by pdfbox-android)

- Components: `org.bouncycastle:bcprov-jdk15to18:1.72`,
  `org.bouncycastle:bcpkix-jdk15to18:1.72`,
  `org.bouncycastle:bcutil-jdk15to18:1.72` (Android app runtime classpath)
- Source: https://www.bouncycastle.org/java.html
- License: Bouncy Castle Licence (a permissive, MIT-style license)
- License text: `licenses/BOUNCYCASTLE-LICENSE.txt` (mirrored from the
  `org/bouncycastle/LICENSE.class` text embedded in bcprov-jdk15to18 1.72,
  copyright 2000-2022 The Legion of the Bouncy Castle Inc.)
- Obligation: retain the copyright and permission notice in distributions.

## Referenced implementations (protocol/feature references, not copied code)

These entries document third-party projects whose published protocol
constants, behavioral descriptions, or design concepts were referenced while
writing Mikeko code. No source files were copied from them.

### NextChat (model vision capability table design)

- Reference: https://github.com/ChatGPTNextWeb/NextChat
- License: MIT (verified via GitHub API on the commit used)
- Usage: `ModelVisionPolicy.kt` (app and shared copies) states that the
  hit-list/exclusion-list runtime-detection design is inspired by NextChat.
  The model capability facts themselves come from vendor documentation.

### zhinjs/qq-official-bot (QQ Open Platform protocol constants)

- Reference: https://github.com/zhinjs/qq-official-bot
- License: MIT (verified 2026-09-15)
- Usage: `QqBotService.kt` uses the QQ Open Platform WebSocket OpCode and
  Intent numeric constants (0/1/2/6/7/9/10/11 and `1 << 25`), which are
  protocol facts published by the QQ Open Platform wiki and cross-checked
  against this SDK. Only protocol constants are used, not SDK code.

### Gadgetbridge (Android database schema interoperability facts)

- Reference: https://codeberg.org/Freeyourgadget/Gadgetbridge
- License: AGPL-3.0 (the upstream project's license)
- Usage: `GadgetbridgeReader.kt` reads the user's Gadgetbridge SQLite database
  (`Gadgetbridge.db`) to display health data. The table/column names, unit
  conventions, and the placeholder-row filter rule
  (`TIMESTAMP <= OTHER_TIMESTAMP`) are interface facts of the database schema,
  documented in comments with references to Gadgetbridge's
  `HuaweiSampleProvider.java` / `getGBActivitySamplesHighRes`. No code from
  Gadgetbridge is copied, translated, or linked; Mikeko only opens the
  database read-only as an interoperability interface. Mikeko's own code
  remains proprietary.

## Ported UI

### Orange Island (橘子岛) health data page

- Source: https://github.com/chloemeadow0-code/Orange-Island
- License: MIT
- Copyright: Copyright (c) 2026 newo-ether / chloemeadow0-code (Orange Island
  contributors)
- Usage: The health data screen (heart rate / steps / sleep / SpO2 charts) in
  `app/src/main/java/com/chloemeadow/mikeko/ui/screens/HealthScreen.kt` and
  `HealthViewModel.kt` is ported from
  `com.orangeisland.app.ui.health.HealthPage` / `HealthViewModel`, adapted to
  mikan's existing Gadgetbridge reader and settings sub-page layout. The
  MIT license notice is preserved in both file headers.

## Desktop distribution runtime

### Bundled Java runtime (jpackage)

The Windows desktop installers (MSI/EXE) bundle a Java runtime derived from
OpenJDK, produced by `jpackage` from the JDK used at build time. This runtime
is licensed under GPL-2.0 with Classpath Exception.

- License text: `licenses/GPL-2.0-WITH-CLASSPATH-EXCEPTION.txt`
- Release requirement: record the exact JDK vendor, distribution, and version
  used for the release build; an open build such as Eclipse Temurin is
  recommended, with the corresponding-source availability reference required
  by the GPL-2.0 + Classpath Exception terms. Building with an Oracle JDK
  additionally requires reviewing Oracle's redistribution terms.

### Compose Multiplatform desktop runtime

The desktop app is built with JetBrains Compose Multiplatform
(`org.jetbrains.compose`), which ships the Skiko Skia bindings (Apache-2.0).
The Skia graphics library (BSD-style terms plus its own third-party
components) is compiled into the native DLL inside
`skiko-awt-runtime-windows-x64`; neither `skiko-awt` nor
`skiko-awt-runtime-windows-x64` 0.150.1 bundles any license, legal, or
notice file (verified 2026-09-14 — the runtime jar contains only the DLL,
its SHA-256 file, and `icudtl.dat`). The applicable texts are mirrored at
`licenses/SKIKO-LICENSE` (skiko, Apache-2.0), `licenses/SKIKO-NOTICE`
(skiko's notice for AOSP-derived code), and `licenses/SKIA-LICENSE` (Skia,
BSD-style); Skia's per-dependency third-party notices must still be taken
from the Skia tree matching the skiko build and included in the release
materials.

### OpenJFX runtime modules (desktop HTML artifact preview WebView)

- Components: `org.openjfx:javafx-base`, `javafx-graphics`, `javafx-controls`,
  `javafx-media`, `javafx-web`, `javafx-swing`, version 21.0.8 with the
  `:win` classifier; declared explicitly in `desktop/build.gradle.kts`
  (six modules, `isTransitive = false`).
- License: GNU General Public License, version 2, with the Classpath
  exception
- License text: `licenses/GPL-2.0-WITH-CLASSPATH-EXCEPTION.txt`
- Corresponding-source reference: OpenJFX 21.0.8 — tag `21.0.8+2` in
  https://github.com/openjdk/jfx21u
  (recorded 2026-09-14; re-pin the exact tag on every version bump)
- Release obligation: see `RELEASE_COMPLIANCE.md`「Copyleft source-delivery
  obligations」. The six jars bundle no license/legal/notice files;
  `javafx-web` embeds a WebKit build whose sources are largely LGPL-2.1 and
  `javafx-media` links platform media frameworks — preserve their notices
  from the matching OpenJFX source tag before release.

### sqlite-jdbc (SQLite JDBC Driver)

- Component: `org.xerial:sqlite-jdbc:3.41.2.2`
- Scope: desktop module only; used to open Android Room databases for backup
  import/export (`ConversationsDb`, `MemoryDb`, `ProjectsDb`, `AiSpaceDb`)
- Source: https://github.com/xerial/sqlite-jdbc
- License: Apache-2.0 (declared by the artifact POM)
- License text: the JAR bundles no Apache-2.0 text. It carries
  `META-INF/maven/org.xerial/sqlite-jdbc/LICENSE.zentus`, a BSD-style notice
  (Copyright 2006 David Crawshaw) covering legacy driver portions, mirrored
  verbatim at `licenses/SQLITE-JDBC-LICENSE.zentus`. Apache-2.0 itself is
  not reproduced separately in the `licenses/` directory, consistent with
  the project's handling of all other Apache-2.0 dependencies.
- Copyright: Taro L. Saito and contributors
- Embedded library: the JAR bundles pre-compiled SQLite native binaries.
  SQLite itself is in the public domain (https://www.sqlite.org/copyright.html).

Obligation: keep the attribution above (Apache-2.0 per the POM, plus the
bundled BSD-style LICENSE.zentus notice) in the distribution via the release
materials — the desktop ProGuard/packaging stage drops these META-INF files
(verified 2026-09-14). The embedded SQLite native library is public domain
and requires no separate attribution.

### slf4j-api (transitive)

- Component: `org.slf4j:slf4j-api:2.0.17` — pulled into the desktop runtime
  classpath by Ktor, and into the Android runtime classpath by the MCP Kotlin
  SDK / Ktor server-websockets; not a declared dependency in either module
- License: MIT — the artifact POM declares no license; the MIT text is
  bundled in the JAR at `META-INF/LICENSE.txt` and mirrored at
  `licenses/SLF4J-LICENSE.txt` (hash-verified against the 2.0.17 jar,
  2026-09-15)
- Copyright: QOS.ch Sarl (Switzerland)
- Obligation: retain the MIT notice in distributions via the release
  materials; no source delivery is required.

## Direct JVM and Android dependencies

The application directly declares the following open-source dependencies. The
license named here is a release-audit aid; the license files and notices in the
resolved artifacts remain authoritative.

| Component | Declared version | License family |
| --- | ---: | --- |
| AndroidX Core, Activity, Lifecycle, Navigation | see `app/build.gradle.kts` | Apache-2.0 |
| AndroidX Media3 (ExoPlayer, Session, UI) | 1.10.1 | Apache-2.0 |
| AndroidX CameraX (core, camera2, lifecycle) | 1.4.1 | Apache-2.0 |
| AndroidX Room | 2.8.4 | Apache-2.0 |
| AndroidX WorkManager | 2.10.0 | Apache-2.0 |
| AndroidX ExifInterface | 1.3.7 | Apache-2.0 |
| Jetpack Compose (BOM 2026.05.01) and Material 3 | see build file | Apache-2.0 |
| Compose Multiplatform desktop (incl. Skiko) | see `desktop/build.gradle.kts` | Apache-2.0; Skia BSD-style |
| OpenJFX (base/graphics/controls/media/web/swing, `:win`) | 21.0.8 | GPL-2.0+CE; see Desktop distribution runtime section |
| Kotlin coroutines (core, Android, Swing, play-services) and serialization | see build files | Apache-2.0 |
| OkHttp | 5.3.2 | Apache-2.0 |
| Coil (Android 2.7.0; desktop Coil 3 3.6.0) | see build files | Apache-2.0 |
| PdfBox-Android | 2.0.27.0 | Apache-2.0 |
| QuickJS-KT | 1.0.5 | Apache-2.0; embeds the QuickJS engine (MIT) |
| MCP Kotlin SDK (client, core) | 0.14.0 | MIT; see the MCP Kotlin SDK section |
| Ktor client and SSE | 3.4.3 | Apache-2.0 |
| Haze (blur/glass effects) | 1.7.2 | Apache-2.0 |
| jlatexmath-android | 1.5 | GPL-2.0+CE; see section above |
| jsch | 0.2.23 | BSD-style; see section above |
| Google Play services (Location) | 21.3.0 | Google Play SDK terms (proprietary, not open source) |
| desugar_jdk_libs | 2.1.5 | GPL-2.0 with Classpath Exception; see `licenses/GPL-2.0-WITH-CLASSPATH-EXCEPTION.txt` |
| sqlite-jdbc | 3.41.2.2 | Apache-2.0; embeds SQLite (public domain); desktop module only |
| JUnit | 4.13.2 | EPL-1.0; test-only, not distributed |

`play-services-location` is distributed under Google's SDK terms, not an
open-source license; confirm the terms of the chosen distribution channel
(for example Google Play) before publishing.

## Android runtime transitive audit (2026-09-15)

`:app` `releaseRuntimeClasspath` was resolved on 2026-09-15 and every
non-AndroidX, non-JetBrains component was cross-checked against its artifact
POM and, where bundled, its in-JAR license text. No AGPL, SSPL, or
exception-less GPL component is present. The resolved artifacts that carry
their own notice obligations beyond the direct table are:

| Component | Resolved version | License | Evidence |
| --- | ---: | --- | --- |
| org.bouncycastle:bcprov / bcpkix / bcutil | 1.72 | Bouncy Castle Licence | POM + in-JAR `LICENSE.class`; see section above |
| org.slf4j:slf4j-api | 2.0.17 | MIT | in-JAR `META-INF/LICENSE.txt` |
| io.github.oshai:kotlin-logging (and `-android`) | 8.0.4 | Apache-2.0 | POM |
| com.typesafe:config | 1.4.5 | Apache-2.0 | POM |
| org.fusesource.jansi:jansi | 2.4.2 | Apache-2.0 | POM |
| com.google.accompanist:accompanist-drawablepainter | 0.32.0 | Apache-2.0 | POM |
| com.google.guava:guava (android), failureaccess, listenablefuture | 33.3.1-android | Apache-2.0 | upstream license |
| com.google.auto.value:auto-value-annotations | 1.6.3 | Apache-2.0 | upstream license |
| org.jspecify:jspecify | 1.0.0 | Apache-2.0 | POM |
| com.squareup.okio:okio / okio-jvm | 3.16.4 | Apache-2.0 | POM |
| com.android.tools:desugar_jdk_libs_configuration | 2.1.5 | BSD-3-Clause | POM (build-time only, not in APK) |

`okhttp:4.12.0` appears only as a version-constraint line and resolves to
`okhttp:5.3.2`; `kotlinx-coroutines`, `kotlinx-serialization`, and
`kotlinx-io` resolve to 1.11.0 / 0.9.1 under their BOMs — all Apache-2.0.
Apache-2.0 text is not reproduced per-component, consistent with the
project's handling of all other Apache-2.0 dependencies.

## Asset provenance resolution (2026-09-15)

The following Android image assets initially had no row in
`ASSET_PROVENANCE.csv`. On 2026-09-15 the project owner confirmed they are
original artwork by the Mikeko development team; the CSV rows have been
completed accordingly (`creator` = 小橘 (Mikeko team), `source` = Original
artwork by the Mikeko development team, `license` = Copyright Mikeko
development team; all rights reserved):

- `app/src/main/assets/game-covers/*.png` (8 files: 2048, chess, flappy,
  minesweeper, snake, sudoku, tetris, wordle)
- `app/src/main/res/drawable-nodpi/diary_weather_*.png` (8 files)
- `app/src/main/res/drawable-nodpi/mikeko_bg_kraft.webp`
- `app/src/main/res/drawable-nodpi/mikeko_bg_rouge.webp`

Before release, resolve the complete runtime dependency graph of both `:app`
and `:desktop` and preserve all notices bundled by transitive dependencies. Do
not rely on this direct-only table as the complete binary notice inventory.
