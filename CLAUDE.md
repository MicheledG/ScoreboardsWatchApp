# Scoreboards

watchOS app + widget for tracking two-team scores.

## Tech Stack

- Swift 5.0+, SwiftUI
- watchOS 11.2+ deployment target
- WidgetKit (complications: circular + corner)
- App Group: `group.com.micheledg.Scoreboards` for cross-target UserDefaults
- Xcode project (no SPM/CocoaPods)

## Project Structure

```
Scoreboards Watch App/
  ScoreboardsApp.swift         # App entry point
  ScoreboardsView.swift        # Root view, TeamScoreView component
  ScoreStore.swift             # Observable state + App Group persistence + WidgetKit reload
  ScoreboardsApp.entitlements  # App Group capability

Scoreboards Widget/
  ScoreboardsWidget.swift              # Timeline provider, widget UI (circular + corner)
  ScoreboardsWidgetBundle.swift        # Widget bundle entry
  Scoreboards_Widget.entitlements      # App Group capability

Scoreboards Watch App Tests/
  ScoreStoreTests.swift   # Unit tests (needs test target added in Xcode — see README)
```

## Architecture

Two targets sharing state via **App Group UserDefaults** (`group.com.micheledg.Scoreboards`).

`ScoreStore` (ObservableObject) owns all mutable state:
- `scoreTeam1`, `scoreTeam2`, `lastScoringTeam: ScoringTeam?`
- Persists to App Group defaults on every mutation
- Calls `WidgetCenter.shared.reloadAllTimelines()` after every change

Widget reads from the same App Group defaults in `Provider`. Timeline policy is `.never` — the app drives reloads via `WidgetCenter`.

## Bundle IDs

- Watch App: `com.micheledg.Scoreboards.watchkitapp`
- Widget: `com.micheledg.Scoreboards.watchkitapp.Scoreboards-Widget`
- Container: `com.micheledg.Scoreboards`
- Team ID: `J2T5LM22RS`

## Key Types

- `ScoringTeam: String, CaseIterable` enum — `team1`, `team2`
- `ScoreStore: ObservableObject` — `scorePoint(for:)`, `removePoint(for:)`, `reset()`
- `ScoreStore(suiteName:)` — testable initializer, defaults to production App Group

## Important Notes

- App Group must be registered in Apple Developer portal before building for device
- Tests need a Xcode Unit Testing Bundle target (see README for steps)
- Icon generated programmatically via `/tmp/gen_icon.swift` Swift script

## Build

Open `Scoreboards.xcodeproj` in Xcode. Select watch simulator or paired device. Build & run.
