import SwiftUI
import WidgetKit

enum ScoringTeam: String, CaseIterable {
    case team1, team2

    var displayName: String {
        switch self {
        case .team1: "Team 1"
        case .team2: "Team 2"
        }
    }
}

final class ScoreStore: ObservableObject {
    static let appGroup = "group.com.micheledg.Scoreboards"

    private let defaults: UserDefaults

    @Published private(set) var scoreTeam1: Int
    @Published private(set) var scoreTeam2: Int
    @Published private(set) var lastScoringTeam: ScoringTeam?

    init(suiteName: String = appGroup) {
        defaults = UserDefaults(suiteName: suiteName) ?? .standard
        scoreTeam1 = defaults.integer(forKey: "scoreTeam1")
        scoreTeam2 = defaults.integer(forKey: "scoreTeam2")
        lastScoringTeam = defaults.string(forKey: "lastScoringTeam").flatMap(ScoringTeam.init(rawValue:))
    }

    func scorePoint(for team: ScoringTeam) {
        switch team {
        case .team1: scoreTeam1 += 1
        case .team2: scoreTeam2 += 1
        }
        lastScoringTeam = team
        persist()
    }

    func removePoint(for team: ScoringTeam) {
        switch team {
        case .team1: scoreTeam1 = max(0, scoreTeam1 - 1)
        case .team2: scoreTeam2 = max(0, scoreTeam2 - 1)
        }
        lastScoringTeam = nil
        persist()
    }

    func reset() {
        scoreTeam1 = 0
        scoreTeam2 = 0
        lastScoringTeam = nil
        persist()
    }

    private func persist() {
        defaults.set(scoreTeam1, forKey: "scoreTeam1")
        defaults.set(scoreTeam2, forKey: "scoreTeam2")
        if let lastScoringTeam {
            defaults.set(lastScoringTeam.rawValue, forKey: "lastScoringTeam")
        } else {
            defaults.removeObject(forKey: "lastScoringTeam")
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
}
