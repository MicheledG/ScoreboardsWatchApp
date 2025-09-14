//
//  ScoreboardsApp.swift
//  Scoreboards Watch App
//
//  Created by Michele Di Girolamo on 01/02/25.
//

import SwiftUI

@main
struct Scoreboards_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ScoreboardsView()
                .onOpenURL { url in
                    // Handle the URL from the widget
                    if url.scheme == "scoreboards" && url.host == "open" {
                        // The app is already opening, no additional action needed
                        print("App opened from widget")
                    }
                }
        }
    }
}
