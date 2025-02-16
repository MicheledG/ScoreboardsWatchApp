//
//  ContentView.swift
//  Scoreboards Watch App
//
//  Created by Michele Di Girolamo on 01/02/25.
//

import SwiftUI

struct ScoreboardsView: View {
    @State private var scoreTeam1 = 0
    @State private var scoreTeam2 = 0
    @State private var lastTeamScoring = ""
    
    private let longPressDuration: Double = 1.5
    
    var body: some View {
        VStack {
            TeamScoreView(teamName: "Team 1", score: $scoreTeam1, lastTeamScoring: $lastTeamScoring)
            TeamScoreView(teamName: "Team 2", score: $scoreTeam2, lastTeamScoring: $lastTeamScoring)
            
            Button("Reset") {}
            .foregroundColor(.red)
            .simultaneousGesture(
                LongPressGesture(minimumDuration: longPressDuration).onEnded { _ in
                    scoreTeam1 = 0
                    scoreTeam2 = 0
                    lastTeamScoring = ""
                }
            )
        }
    }
}

struct TeamScoreView: View {
    let teamName: String
    @Binding var score: Int
    @Binding var lastTeamScoring: String
    
    var body: some View {
        VStack {
            Text(teamName).font(.headline)
            Stepper{
                Text("\(score)")
                    .frame(maxWidth: .infinity)
                    .background(
                        lastTeamScoring == teamName ? Color.green.opacity(0.3) : Color.clear
                    )
                    .cornerRadius(8)
            } onIncrement: {
                score += 1
                lastTeamScoring = teamName
            } onDecrement: {
                score -= 1
            }
        }
    }
}

#Preview {
    ScoreboardsView()
}
