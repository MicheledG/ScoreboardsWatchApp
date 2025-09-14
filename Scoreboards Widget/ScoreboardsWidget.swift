//
//  ScoreboardsWidget.swift
//  Scoreboards Widget
//
//  Created by Michele Di Girolamo on 13/09/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date())
        // Static timeline since this is just an app launcher
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ScoreboardsWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        ZStack {
            switch family {
            case .accessoryCircular:
                // Circular complication - 110px source image
                Image("app-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    
            case .accessoryCorner:
                // Corner complication - 80px source image
                Image("app-icon-small")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    
            default:
                // Not supported - show nothing or minimal fallback
                EmptyView()
            }
        }
        .widgetURL(URL(string: "scoreboards://open"))
        .containerBackground(for: .widget) {
            Color.clear
        }
    }
}

struct ScoreboardsWidget: Widget {
    let kind: String = "ScoreboardsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ScoreboardsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Scoreboards")
        .description("Quick access to your Scoreboards app")
        .supportedFamilies([.accessoryCircular, .accessoryCorner])
    }
}

#Preview("Circular", as: .accessoryCircular) {
    ScoreboardsWidget()
} timeline: {
    SimpleEntry(date: Date())
}

#Preview("Corner", as: .accessoryCorner) {
    ScoreboardsWidget()
} timeline: {
    SimpleEntry(date: Date())
}
