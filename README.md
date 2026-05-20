# e& Video Player — Multi-Platform Demo

A Flutter video player built for **e& (Etisalat)** that runs on phones, tablets, and Smart TVs from one shared codebase.

---

## ✅ Supported Platforms

| Platform | How it runs |
|---|---|
| Android Phone | Flutter native |
| Android TV | Flutter native (TV UI auto-detected) |
| iOS / iPhone | Flutter native |
| **Apple TV (tvOS)** | Custom Flutter engine via shell script |
| Web | Flutter Web |
| **LG webOS TV** | Flutter Web build injected into webOS app template |
| **Samsung Tizen TV** | Flutter + Tizen SDK + Tizen plugins |

---

## 🎥 Demo Videos

| Platform | Demo |
|----------|------|
| iPhone / Android / Web / Android TV | [Watch Demo](https://drive.google.com/file/d/1eE6dR9pv5gKG8l-tleKi7Pu79HIR3RXz/view?usp=drive_link) |
| iOS | [Watch Demo](https://drive.google.com/file/d/19Z_H2Q2IN2H1M2rIFvYi11_mBdu0qc8b/view?usp=drive_link) |
| LG webOS | [Watch Demo](https://drive.google.com/file/d/1IsjlXWaRNNZKFTrN3t-9elNBWGu9mDGu/view?usp=sharing) |

---

## 🌿 Branch Structure

```
main                  → Standard build (Android, iOS, Web)
web-tvos-lg-tizen     → Adds Apple TV + LG webOS + Samsung Tizen support
```

---

## 🚀 Quick Start

```bash
flutter pub get
flutter run
```

> The app automatically detects TV vs phone on Android via a native `MethodChannel` and routes to the correct UI.

---

## 📱 Running on Each Platform

### Android & iOS
```bash
flutter run -d <device-id>
```

---

### 🍎 Apple TV (tvOS)
Uses a custom Flutter engine compiled for tvOS. Run via the provided script:

```bash
sh scripts/run_apple_tv.sh debug_sim_arm64    # Simulator (ARM64)
sh scripts/run_apple_tv.sh debug_sim_x86      # Simulator (x86_64)
sh scripts/run_apple_tv.sh debug_device       # Physical Apple TV
sh scripts/run_apple_tv.sh release_device     # Release on device
```

---

### 📺 LG webOS TV
LG webOS doesn't support Flutter natively. The workaround:

1. Build Flutter for Web:
   ```bash
   flutter build web --release
   ```

2. Copy the output into the webOS template:
   ```bash
   cp -r build/web/* lg_webos_app/assets/
   ```

3. Package and deploy with the LG webOS CLI:
   ```bash
   ares-package lg_webos_app
   ares-install --device <tv-name> com.etisalat.tv_1.0.0_all.ipk
   ares-launch  --device <tv-name> com.etisalat.tv
   ```

> The `lg_webos_app/` folder is a pre-made webOS app template. Flutter Web assets are injected at build time and rendered by the webOS Chromium engine.

---

### 📺 Samsung Tizen TV
Switch to the `web-tvos-lg-tizen` branch. The `pubspec.yaml` uses Tizen plugin overrides:

```yaml
dependencies:
  video_player: ^2.9.3
  video_player_tizen: ^2.5.11       # replaces video_player on Tizen
  shared_preferences: ^2.3.4
  shared_preferences_tizen: ^2.1.2  # replaces shared_preferences on Tizen
```

Deploy using the `flutter-tizen` CLI:
```bash
flutter-tizen run -d <tizen-device-id>
flutter-tizen build tpk --release     # release package
```

> ⚠️ **Apple Silicon limitation** — Tizen Studio (required to run Samsung TV targets) only supports **Intel (x86_64)** architecture. This project was developed on an **Apple M4** machine, which means the Tizen emulator and device runner could not be launched locally despite all configuration being fully in place in `pubspec.yaml`. All Tizen plugin overrides (`video_player_tizen`, `shared_preferences_tizen`) and the `tizen/` platform folder are committed and ready — the build will work on an Intel machine or CI environment with Tizen Studio installed.

---

## 🏗️ Architecture

**Feature-first MVVM** with `Provider` for state management.

```
main.dart
  └─ PlatformService.isTV()           ← native MethodChannel check
       └─ App(isTV: bool)
            └─ ChangeNotifierProvider<PlayerViewModel>
                 └─ SplashScreen
                      └─ TvPlayerScreen  ──or──  PhonePlayerScreen
```

### Folder layout

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # Root widget + Provider setup
├── core/
│   ├── platform/platform_service.dart # TV detection (MethodChannel)
│   ├── services/
│   │   ├── playback_service.dart      # Throttled save (every 5 s)
│   │   └── playback_storage.dart      # SharedPreferences wrapper
│   ├── theme/app_theme.dart           # Cinema dark theme + TV scale tokens
│   └── widgets/phone_seek_bar.dart
└── features/
    ├── splash/splash_screen.dart
    └── video/presentation/
        ├── controller/player_viewmodel.dart   # All playback logic
        └── view/
            ├── tv/     # D-pad controls, focus glow, 10-foot seek bar
            └── phone/  # Touch controls, horizontal layout

lg_webos_app/   # webOS app wrapper (assets/ injected from flutter build web)
tizen/          # Samsung Tizen platform project + engine bindings
scripts/
└── run_apple_tv.sh   # Launches tvOS via custom Flutter engine
```

---

## 🎬 Key Features

- **Adaptive UI** — Phone and TV layouts are completely separate; the right one is picked at startup
- **TV Remote / D-pad navigation** — Full focus management with a visible green glow ring
- **Skip controls** — ±10 seconds, debounced (300 ms) to prevent double-triggers
- **Resume playback** — Last position saved to `SharedPreferences` and restored on next launch
- **Throttled writes** — Position saved at most once every 5 s during playback; forced on pause or dispose
- **Auto-hide controls** — Overlay fades after 3 seconds of uninterrupted playback
- **Cinema dark theme** — `#121212` background, e& brand red (`#F30013`) accents, TV sizes scale 1.5×

---

## 💾 Playback Resume

| Trigger | Behaviour |
|---|---|
| Playing | Save position every **5 seconds** |
| Pause | Force-save **immediately** |
| App closed / disposed | Force-save **immediately** |
| Next launch | Restore saved position before first frame |

Key stored in `SharedPreferences`: `last_playback_position_ms`

---

## 📦 Dependencies

| Package | Version | Purpose |
|---|---|---|
| `video_player` | `^2.9.3` | Video playback — Android, iOS, Web |
| `video_player_tizen` | `^2.5.11` | Tizen platform override |
| `shared_preferences` | `^2.3.4` | Position persistence |
| `shared_preferences_tizen` | `^2.1.2` | Tizen platform override |
| `provider` | `^6.1.2` | State management |

---

> Internal demo — not published to pub.dev. © e& (Etisalat).
