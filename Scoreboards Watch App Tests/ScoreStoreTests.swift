// NOTE: To run these tests, add a watchOS Unit Testing Bundle target in Xcode
// (File > New > Target > watchOS > Unit Testing Bundle) and add this folder
// to its file system synchronized group. The test target must link ScoreStore.swift.

import XCTest
@testable import Scoreboards_Watch_App

final class ScoreStoreTests: XCTestCase {
    var store: ScoreStore!

    override func setUp() {
        super.setUp()
        // Use a test-specific suite so tests don't pollute production defaults
        UserDefaults(suiteName: "group.com.micheledg.Scoreboards.test")?.removePersistentDomain(forName: "group.com.micheledg.Scoreboards.test")
        store = ScoreStore(suiteName: "group.com.micheledg.Scoreboards.test")
    }

    func testInitialScoresAreZero() {
        XCTAssertEqual(store.scoreTeam1, 0)
        XCTAssertEqual(store.scoreTeam2, 0)
        XCTAssertNil(store.lastScoringTeam)
    }

    func testScorePointIncrementsCorrectTeam() {
        store.scorePoint(for: .team1)
        XCTAssertEqual(store.scoreTeam1, 1)
        XCTAssertEqual(store.scoreTeam2, 0)

        store.scorePoint(for: .team2)
        XCTAssertEqual(store.scoreTeam2, 1)
    }

    func testScorePointSetsLastScoringTeam() {
        store.scorePoint(for: .team1)
        XCTAssertEqual(store.lastScoringTeam, .team1)

        store.scorePoint(for: .team2)
        XCTAssertEqual(store.lastScoringTeam, .team2)
    }

    func testRemovePointDecrementsCorrectTeam() {
        store.scorePoint(for: .team1)
        store.scorePoint(for: .team1)
        store.removePoint(for: .team1)
        XCTAssertEqual(store.scoreTeam1, 1)
    }

    func testRemovePointClearsLastScoringTeam() {
        store.scorePoint(for: .team1)
        store.removePoint(for: .team1)
        XCTAssertNil(store.lastScoringTeam)
    }

    func testRemovePointDoesNotGoBelowZero() {
        store.removePoint(for: .team1)
        XCTAssertEqual(store.scoreTeam1, 0)

        store.removePoint(for: .team2)
        XCTAssertEqual(store.scoreTeam2, 0)
    }

    func testResetClearsAllState() {
        store.scorePoint(for: .team1)
        store.scorePoint(for: .team1)
        store.scorePoint(for: .team2)
        store.reset()
        XCTAssertEqual(store.scoreTeam1, 0)
        XCTAssertEqual(store.scoreTeam2, 0)
        XCTAssertNil(store.lastScoringTeam)
    }

    func testScoresPersistedAcrossInstances() {
        store.scorePoint(for: .team1)
        store.scorePoint(for: .team1)
        store.scorePoint(for: .team2)

        let store2 = ScoreStore(suiteName: "group.com.micheledg.Scoreboards.test")
        XCTAssertEqual(store2.scoreTeam1, 2)
        XCTAssertEqual(store2.scoreTeam2, 1)
        XCTAssertEqual(store2.lastScoringTeam, .team2)
    }
}
