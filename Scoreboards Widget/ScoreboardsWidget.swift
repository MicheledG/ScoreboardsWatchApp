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
                // Circular complication - show app icon
                Image("app-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
                    
            case .accessoryCorner:
                // Corner complication - smaller app icon
                Image("app-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    
            case .accessoryInline:
                // Inline complication - app icon with text
                HStack(spacing: 4) {
                    Image("app-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                    Text("Scoreboards")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
                
            default:
                // Fallback for other sizes
                Image("app-icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
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
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline])
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

#Preview("Inline", as: .accessoryInline) {
    ScoreboardsWidget()
} timeline: {
    SimpleEntry(date: Date())
}
