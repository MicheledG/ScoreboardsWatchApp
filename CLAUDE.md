# Scoreboards

watchOS app + widget for tracking two-team scores.

## Tech Stack

- Swift 5.0+, SwiftUI
- watchOS 7.0+ deployment target
- WidgetKit (complications)
- Xcode project (no SPM/CocoaPods)

## Project Structure

```
Scoreboards Watch App/   # Main watchOS app
  ScoreboardsApp.swift   # Entry point, deep link handler (scoreboards://open)
  ScoreboardsView.swift  # Root view, TeamScoreView component

Scoreboards Widget/      # WidgetKit extension
  ScoreboardsWidget.swift        # Timeline provider, widget UI (circular + corner)
  ScoreboardsWidgetBundle.swift  # Widget bundle entry
  AppIntent.swift                # Placeholder, not yet implemented
```

## Architecture

Two targets sharing no code module — widget reads no live data (static timeline). Widget taps deep-link to app via `scoreboards://open`, handled in `ScoreboardsApp.swift:15` `onOpenURL`.

State lives entirely in `ScoreboardsView`: `scoreTeam1`, `scoreTeam2`, `lastTeamScoring` — no persistence layer.

## Key Behaviors

- Score increment/decrement via `Stepper` in `TeamScoreView`
- Last scoring team highlighted green (`lastTeamScoring` state)
- Reset: 1.5s long press
- Widget: two complication styles (circular, corner), static, taps open app

## No Tests

No test targets exist.

## Build

Open `Scoreboards.xcodeproj` in Xcode. Select watch simulator or paired device. Build & run.
