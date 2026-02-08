import Testing

@testable import PureRank

@Suite struct MultiTeamMatchTests {
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

    let teamC = Team(players: [
      Player(id: "Kevin", mean: 28, deviation: 4),
      Player(id: "Laura", mean: 26, deviation: 5),
      Player(id: "Michael", mean: 24, deviation: 6),
      Player(id: "Natalie", mean: 22, deviation: 7),
      Player(id: "Olivia", mean: 20, deviation: 8),
    ])

    let match = TeamFreeForAll(teams: [teamA, teamB, teamC])
    let result = UpdateSkill().teamFreeForAll(match)

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

    expectPlayer(id: "Frank", mean: 31.85, deviation: 2.97)
    expectPlayer(id: "Grace", mean: 28.57, deviation: 4.86)
    expectPlayer(id: "Heidi", mean: 26.37, deviation: 5.75)
    expectPlayer(id: "Ivan", mean: 24.12, deviation: 6.62)
    expectPlayer(id: "Judy", mean: 21.82, deviation: 7.43)

    expectPlayer(id: "Kevin", mean: 27.60, deviation: 3.96)
    expectPlayer(id: "Laura", mean: 25.37, deviation: 4.94)
    expectPlayer(id: "Michael", mean: 23.09, deviation: 5.88)
    expectPlayer(id: "Natalie", mean: 20.77, deviation: 6.82)
    expectPlayer(id: "Olivia", mean: 18.39, deviation: 7.73)
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

    let teamC = Team(players: [
      Player(id: "Kevin", mean: 28, deviation: 4),
      Player(id: "Laura", mean: 26, deviation: 5),
      Player(id: "Michael", mean: 24, deviation: 6),
      Player(id: "Natalie", mean: 22, deviation: 7),
      Player(id: "Olivia", mean: 20, deviation: 8),
    ])

    let match = TeamFreeForAll(teams: [teamA, teamB, teamC])
    let result = UpdateSkill().teamFreeForAll(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    for id in [
      "Alice", "Bob", "Carol", "Dave", "Eve",
      "Frank", "Grace", "Heidi", "Ivan", "Judy",
      "Kevin", "Laura", "Michael", "Natalie", "Olivia",
    ] {
      try expectDeviationDecrease(id: id)
    }
  }
}
