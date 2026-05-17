//
//  ScoreboardsWidget.swift
//  Scoreboards Widget
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    private let appGroup = "group.com.micheledg.Scoreboards"

    private func currentEntry() -> ScoreEntry {
        let defaults = UserDefaults(suiteName: appGroup) ?? .standard
        return ScoreEntry(
            date: Date(),
            scoreTeam1: defaults.integer(forKey: "scoreTeam1"),
            scoreTeam2: defaults.integer(forKey: "scoreTeam2"),
            lastScoringTeam: defaults.string(forKey: "lastScoringTeam")
        )
    }

    func placeholder(in context: Context) -> ScoreEntry {
        ScoreEntry(date: Date(), scoreTeam1: 3, scoreTeam2: 1, lastScoringTeam: "team1")
    }

    func getSnapshot(in context: Context, completion: @escaping (ScoreEntry) -> ()) {
        completion(context.isPreview ? placeholder(in: context) : currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScoreEntry>) -> ()) {
        // App calls WidgetCenter.reloadAllTimelines() on every score change — .never is correct
        let timeline = Timeline(entries: [currentEntry()], policy: .never)
        completion(timeline)
    }
}

struct ScoreEntry: TimelineEntry {
    let date: Date
    let scoreTeam1: Int
    let scoreTeam2: Int
    let lastScoringTeam: String?
}

struct ScoreboardsWidgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            switch family {
            case .accessoryCircular:
                circularView
            case .accessoryCorner:
                cornerView
            default:
                EmptyView()
            }
        }
        .widgetURL(URL(string: "scoreboards://open"))
        .containerBackground(for: .widget) { Color.clear }
    }

    private var circularView: some View {
        VStack(spacing: 0) {
            scoreText(entry.scoreTeam1, team: "team1")
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.secondary.opacity(0.5))
                .padding(.horizontal, 4)
            scoreText(entry.scoreTeam2, team: "team2")
        }
    }

    private var cornerView: some View {
        Image("app-icon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20, height: 20)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .widgetLabel("\(entry.scoreTeam1) – \(entry.scoreTeam2)")
    }

    private func scoreText(_ score: Int, team: String) -> some View {
        Text("\(score)")
            .font(.system(.title3, design: .rounded, weight: .bold))
            .foregroundColor(entry.lastScoringTeam == team ? .green : .primary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ScoreboardsWidget: Widget {
    let kind: String = "ScoreboardsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScoreboardsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Scoreboards")
        .description("Live score tracker for two teams")
        .supportedFamilies([.accessoryCircular, .accessoryCorner])
    }
}

#Preview("Circular", as: .accessoryCircular) {
    ScoreboardsWidget()
} timeline: {
    ScoreEntry(date: Date(), scoreTeam1: 3, scoreTeam2: 1, lastScoringTeam: "team1")
}

#Preview("Corner", as: .accessoryCorner) {
    ScoreboardsWidget()
} timeline: {
    ScoreEntry(date: Date(), scoreTeam1: 3, scoreTeam2: 1, lastScoringTeam: "team1")
}
