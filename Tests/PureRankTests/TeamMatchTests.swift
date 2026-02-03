import Testing

@testable import PureRank

@Suite struct TeamMatchTests {
  @Test func playerUpdates() async throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
      Player(id: "Dave", mean: 24, deviation: 8),
      Player(id: "Eve", mean: 22, deviation: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, deviation: 3),
      Player(id: "Grace", mean: 29, deviation: 5),
      Player(id: "Heidi", mean: 27, deviation: 6),
      Player(id: "Ivan", mean: 25, deviation: 7),
      Player(id: "Judy", mean: 23, deviation: 8),
    ])

    let match = TeamMatch(teamA: teamA, teamB: teamB, winnerSide: .sideA)
    let result = UpdateSkill().teamMatch(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01,
        )
      )
    }

    expectPlayer(id: "Alice", mean: 30.66, deviation: 3.96)
    expectPlayer(id: "Bob", mean: 29.49, deviation: 5.86)
    expectPlayer(id: "Carol", mean: 27.03, deviation: 4.92)
    expectPlayer(id: "Dave", mean: 26.65, deviation: 7.67)
    expectPlayer(id: "Eve", mean: 24.03, deviation: 6.78)

    expectPlayer(id: "Frank", mean: 31.63, deviation: 2.98)
    expectPlayer(id: "Grace", mean: 27.96, deviation: 4.92)
    expectPlayer(id: "Heidi", mean: 25.50, deviation: 5.86)
    expectPlayer(id: "Ivan", mean: 22.97, deviation: 6.78)
    expectPlayer(id: "Judy", mean: 20.34, deviation: 7.67)
  }

  @Test func uncertaintyDecrease() throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
      Player(id: "Dave", mean: 24, deviation: 8),
      Player(id: "Eve", mean: 22, deviation: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, deviation: 3),
      Player(id: "Grace", mean: 29, deviation: 5),
      Player(id: "Heidi", mean: 27, deviation: 6),
      Player(id: "Ivan", mean: 25, deviation: 7),
      Player(id: "Judy", mean: 23, deviation: 8),
    ])

    let match = TeamMatch(teamA: teamA, teamB: teamB, winnerSide: .sideA)
    let result = UpdateSkill().teamMatch(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    for id in [
      "Alice", "Bob", "Carol", "Dave", "Eve",
      "Frank", "Grace", "Heidi", "Ivan", "Judy",
    ] {
      try expectDeviationDecrease(id: id)
    }
  }
}
