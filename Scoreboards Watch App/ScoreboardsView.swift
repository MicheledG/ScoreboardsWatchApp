//
//  ScoreboardsView.swift
//  Scoreboards Watch App
//

import SwiftUI

struct ScoreboardsView: View {
    @StateObject private var store = ScoreStore()
    private let longPressDuration: Double = 1.5

    var body: some View {
        VStack {
            TeamScoreView(team: .team1, store: store)
            TeamScoreView(team: .team2, store: store)

            Button("Reset") {}
                .foregroundColor(.red)
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: longPressDuration).onEnded { _ in
                        store.reset()
                    }
                )
        }
    }
}

struct TeamScoreView: View {
    let team: ScoringTeam
    @ObservedObject var store: ScoreStore

    private var score: Int {
        team == .team1 ? store.scoreTeam1 : store.scoreTeam2
    }

    private var isLastScoring: Bool {
        store.lastScoringTeam == team
    }

    var body: some View {
        VStack {
            Text(team.displayName).font(.headline)
            Stepper {
                Text("\(score)")
                    .frame(maxWidth: .infinity)
                    .background(isLastScoring ? Color.green.opacity(0.3) : Color.clear)
                    .cornerRadius(8)
            } onIncrement: {
                store.scorePoint(for: team)
            } onDecrement: {
                store.removePoint(for: team)
            }
        }
    }
}

#Preview {
    ScoreboardsView()
}
