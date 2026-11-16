# Bite Log 🍜

A fun, gamified iPhone food journal: log meals in seconds, tag cuisines and where food came from, collect passport stamps, complete weekly quests, and level up. **No calorie counting.**

## Run it on your Mac

Requirements: macOS with **Xcode 15 or newer** (iOS 17 SDK) and [Homebrew](https://brew.sh).

```bash
brew install xcodegen
```

```bash
xcodegen generate
```

```bash
open BiteLog.xcodeproj
```

Then in Xcode:
1. Select the **BiteLog** target → **Signing & Capabilities** → choose your Team (a free Apple ID works for running on your own phone).
2. If Xcode complains the bundle ID is taken, change `com.example.bitelog` to something unique, like `com.yourname.bitelog` (also in `project.yml`).
3. Pick an iPhone simulator or your plugged-in iPhone and press **⌘R**.
4. Run the unit tests with **⌘U**.

> The `.xcodeproj` is generated from `project.yml` and is git-ignored. Re-run `xcodegen generate` after adding or removing files.

## What's in v0.1

| Feature | Where |
|---|---|
| Log with photo (camera or library) or just a name | `Views/AddEntryView.swift` |
| Tags: source (home / restaurant / takeout…), cuisine (44), food types, meal, rating, place, companions, notes | `Core/Catalog.swift` |
| "Again?" one-tap re-log of frequent dishes | `Views/TodayView.swift` |
| Food Passport with Bronze / Silver / Gold stamps + shareable stamp image | `Views/PassportView.swift` |
| XP, levels, 21 badges (incl. a secret one), 3 weekly quests with shuffle | `Core/Gamification.swift`, `Views/ProfileView.swift` |
| Celebration sheet for new stamps / badges / quests / level-ups, plus a "+XP" toast | `Views/RewardSheet.swift` |
| History with search, source filter, edit and delete | `Views/HistoryView.swift` |
| Onboarding, CSV export, delete all data | `Views/OnboardingView.swift`, `Views/SettingsView.swift` |

All game progress is **calculated from your entries** (`GameEngine.state`), so editing or deleting a meal always keeps XP, stamps and badges consistent. That logic has no UI dependencies and is covered by `BiteLogTests/GameEngineTests.swift`.

Data is stored on the device with SwiftData. Models are already CloudKit-compatible, so iCloud sync can be switched on once you have a paid Apple Developer account.

## Project layout

```
BiteLog/
  App/         App entry point, AppModel (game state + celebrations)
  Core/        Catalog (cuisines, food types…) and Gamification engine — pure Swift
  Models/      SwiftData FoodEntry
  Views/       SwiftUI screens and shared components
  Utilities/   Image downscaling
  Resources/   Asset catalog (accent color, app icon slot)
BiteLogTests/  Unit tests for the game engine
docs/          Research, feature design, gamification design
project.yml    XcodeGen project spec
```

## Planning docs
- [User research](docs/01-user-research.md)
- [Feature design & MVP scope](docs/02-feature-design.md)
- [Gamification design](docs/03-gamification.md)
