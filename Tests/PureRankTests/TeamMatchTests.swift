import Testing

@testable import PureRank

@Suite struct TeamMatchTests {
  @Test func playerUpdates() async throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, variance: 4),
      Player(id: "Bob", mean: 28, variance: 6),
      Player(id: "Carol", mean: 26, variance: 5),
      Player(id: "Dave", mean: 24, variance: 8),
      Player(id: "Eve", mean: 22, variance: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, variance: 3),
      Player(id: "Grace", mean: 29, variance: 5),
      Player(id: "Heidi", mean: 27, variance: 6),
      Player(id: "Ivan", mean: 25, variance: 7),
      Player(id: "Judy", mean: 23, variance: 8),
    ])

    let match = TeamMatch(teamA: teamA, teamB: teamB, winnerSide: .sideA)
    let result = UpdateSkill().teamMatch(match)

    func expectPlayer(id: String, mean: Double, variance: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          variance: variance, varianceEpsilon: 0.01,
        )
      )
    }

    expectPlayer(id: "Alice", mean: 30.66, variance: 3.96)
    expectPlayer(id: "Bob", mean: 29.49, variance: 5.86)
    expectPlayer(id: "Carol", mean: 27.03, variance: 4.92)
    expectPlayer(id: "Dave", mean: 26.65, variance: 7.67)
    expectPlayer(id: "Eve", mean: 24.03, variance: 6.78)

    expectPlayer(id: "Frank", mean: 31.63, variance: 2.98)
    expectPlayer(id: "Grace", mean: 27.96, variance: 4.92)
    expectPlayer(id: "Heidi", mean: 25.50, variance: 5.86)
    expectPlayer(id: "Ivan", mean: 22.97, variance: 6.78)
    expectPlayer(id: "Judy", mean: 20.34, variance: 7.67)
  }

  @Test func uncertaintyDecrease() throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, variance: 4),
      Player(id: "Bob", mean: 28, variance: 6),
      Player(id: "Carol", mean: 26, variance: 5),
      Player(id: "Dave", mean: 24, variance: 8),
      Player(id: "Eve", mean: 22, variance: 7),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, variance: 3),
      Player(id: "Grace", mean: 29, variance: 5),
      Player(id: "Heidi", mean: 27, variance: 6),
      Player(id: "Ivan", mean: 25, variance: 7),
      Player(id: "Judy", mean: 23, variance: 8),
    ])

    let match = TeamMatch(teamA: teamA, teamB: teamB, winnerSide: .sideA)
    let result = UpdateSkill().teamMatch(match)

    func expectVarianceDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.variance < before.variance)
    }

    for id in [
      "Alice", "Bob", "Carol", "Dave", "Eve",
      "Frank", "Grace", "Heidi", "Ivan", "Judy",
    ] {
      try expectVarianceDecrease(id: id)
    }
  }
}
