<div align="center">

# 🐧 SudoPath

### Learn Linux terminal commands the fun way — Duolingo-style.

**SudoPath** is a gamified mobile app that turns the Linux command line into an addictive, level-by-level adventure. Hearts, streaks, coins, XP, boss battles and a real terminal engine — built with Flutter and Clean Architecture.

</div>
![SudoPath](SudoPath.png).
---

> **Note:** Replace every `<your-username>` below with your real GitHub username before publishing, and drop your screenshots into `docs/screenshots/`.

## 📖 Overview

Most people learn Linux by memorizing commands they forget a week later. SudoPath flips that around: you *play* your way to fluency. Each level is a bite-sized challenge built around a single command (`pwd`, `ls`, `cd`, `chmod`, `grep`, `ssh`…), and at the end of every world a **Boss Bash** drops you into a live terminal where you have to actually solve a task to win.

The app is designed mobile-first with a cyberpunk / terminal aesthetic — neon green, cyber blue, deep black — and supports both **English** and **Turkish** out of the box.

## ✨ Features

- 🎮 **Duolingo-style skill tree** — four worlds, a zig-zag level map, and a mascot that walks the path with you.
- 🧩 **Four question types** — card matching, command ordering, fill-in-the-blank, and multiple choice.
- 💻 **Boss Bash terminal engine** — a real interactive shell simulation where you complete a mission to clear the world.
- ❤️ **Time-based hearts system** — lose a heart on a wrong answer; it regenerates over time (no pay-to-win walls).
- 🪙 **Coins, 🔥 streaks & ⭐ XP** — full progression loop with a shop to spend your earnings.
- ☁️ **Cloud sync** — Firebase Auth (email/password + Google) and Firestore keep progress in sync across devices, with smart local↔cloud merging.
- 🌍 **Localization** — full English & Turkish support via `easy_localization`; zero hardcoded strings.
- 🎁 **Rewarded ads** — optionally watch an ad to refill a heart and keep playing.
- 🌗 **Light & dark themes** — theme toggle baked into the home bar.

## 🛠️ Tech Stack

| Layer | Tools |
|-------|-------|
| **Framework** | Flutter (Dart 3.3+) |
| **State management** | [Riverpod](https://riverpod.dev) |
| **Navigation** | [GoRouter](https://pub.dev/packages/go_router) (declarative + deep links) |
| **Local storage** | [Hive](https://pub.dev/packages/hive) (custom TypeAdapters) |
| **Backend** | Firebase Core, Auth, Cloud Firestore |
| **Auth** | Email/password + Google Sign-In, secure token storage |
| **Localization** | easy_localization (JSON), intl |
| **Functional** | dartz (`Either` for error handling), equatable |
| **Monetization** | google_mobile_ads (rewarded) |
| **Testing** | flutter_test, mocktail, fake_async |

## 🏗️ Architecture

SudoPath follows **Clean Architecture** with a strict, one-way dependency rule. The `domain` layer is pure Dart — it never imports Flutter.

```
UI Widget
  └─► Derived Provider (e.g. heartsProvider)
        └─► StateNotifier (ProgressNotifier)
              └─► Use Case (e.g. LoseHeartUseCase)
                    └─► Repository (abstract)
                          └─► Hive / Firestore implementation
                                └─► Domain Entity
```

| Layer | Depends on | Flutter allowed? |
|-------|------------|------------------|
| `domain` | nothing | ❌ |
| `data` | `domain` | ❌ (except Hive) |
| `presentation` | `domain` + `core` | ✅ |
| `core` | nothing | ✅ |

### Project structure

```
lib/
├── core/            # Shared infra: colors, constants, theme, router
├── domain/          # Entities, abstract repositories, use cases (pure Dart)
├── data/            # Hive models + repository implementations, Firestore sync
└── presentation/    # Screens, widgets, Riverpod providers
    └── screens/
        ├── onboarding/      home/ (skill tree)   lesson/
        ├── boss_bash/       shop/                settings/
        ├── auth/            profile/
```

### Highlight: the hearts system

Hearts aren't stored as a static number — the app persists a `lastHeartLostAt` timestamp and **computes** the current count on every read, refilling one heart per interval. A 1-second timer drives a live MM:SS countdown in the UI.

```dart
int get currentHearts {
  if (hearts >= AppConstants.maxHearts) return hearts;
  if (lastHeartLostAt == null) return hearts;
  final elapsed = DateTime.now().difference(lastHeartLostAt!).inMinutes;
  final recovered = elapsed ~/ AppConstants.heartRefillMinutes;
  return min(hearts + recovered, AppConstants.maxHearts);
}
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK **3.3+** ([install guide](https://docs.flutter.dev/get-started/install))
- A configured Firebase project (for auth + sync)

### Installation

```bash
# 1. Clone the repo
git clone https://github.com/<your-username>/sudopath.git
cd sudopath

# 2. Install dependencies
flutter pub get

# 3. Generate Hive TypeAdapters (if needed)
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

### Firebase setup

This project uses Firebase. Add your own config files (these are **not** committed):

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- generated `lib/firebase_options.dart` (via `flutterfire configure`)

### Build a release APK

```bash
flutter build apk --release
```

> 💡 Add JetBrains Mono `.ttf` files to `assets/fonts/` and uncomment the `fonts:` block in `pubspec.yaml` for the full terminal look.

## 📸 Screenshots

| Skill Tree | Lesson | Boss Bash | Shop |
|:---:|:---:|:---:|:---:|
| _coming soon_ | _coming soon_ | _coming soon_ | _coming soon_ |

<!-- ![Skill Tree](docs/screenshots/skill_tree.png) -->

## 🗺️ Roadmap

- [ ] Worlds 2–4 full content expansion
- [ ] Lottie celebration animations
- [ ] Widget & integration test coverage
- [ ] Leaderboards & social features
- [ ] Google Play Store release

## 🤝 Contributing

Contributions are welcome! A few house rules from the codebase:

1. Each use case calls exactly one repository method.
2. Never import Flutter inside `domain/`.
3. New color → `AppColors`; new text style → `AppTextStyles`; new constant → `AppConstants`.
4. All UI text goes through `easy_localization` — no hardcoded strings.



Released under the **MIT License**. See [`LICENSE`](LICENSE) for details.

## 👤 Author

BATIKAN AVŞAR

*Built with Flutter 💙 — because the terminal should be fun to learn.*

⭐ If you like this project, consider giving it a star!

</div>
