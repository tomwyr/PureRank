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

    let match = TeamDuel(teamA: teamA, teamB: teamB, winnerSide: .sideA)
    let result = UpdateSkill().teamDuel(match)

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

    let match = TeamDuel(teamA: teamA, teamB: teamB, winnerSide: .sideA)
    let result = UpdateSkill().teamDuel(match)

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

  @Test func teamDuelWithDrawsPlayerUpdates() async throws {
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

    let match = TeamDuelWithDraws(teamA: teamA, teamB: teamB, outcome: .draw)
    let result = UpdateSkill().teamDuelWithDraws(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01,
        )
      )
    }

    expectPlayer(id: "Alice", mean: 30.15, deviation: 3.95)
    expectPlayer(id: "Bob", mean: 28.33, deviation: 5.83)
    expectPlayer(id: "Carol", mean: 26.23, deviation: 4.90)
    expectPlayer(id: "Dave", mean: 24.58, deviation: 7.60)
    expectPlayer(id: "Eve", mean: 22.45, deviation: 6.73)

    expectPlayer(id: "Frank", mean: 31.92, deviation: 2.98)
    expectPlayer(id: "Grace", mean: 28.77, deviation: 4.90)
    expectPlayer(id: "Heidi", mean: 26.67, deviation: 5.83)
    expectPlayer(id: "Ivan", mean: 24.55, deviation: 6.73)
    expectPlayer(id: "Judy", mean: 22.42, deviation: 7.60)
  }

  @Test func teamDuelWithDrawsUncertaintyDecrease() throws {
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

    let match = TeamDuelWithDraws(teamA: teamA, teamB: teamB, outcome: .draw)
    let result = UpdateSkill().teamDuelWithDraws(match)

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

  @Test func teamDuelWithDrawsWinPlayerUpdates() async throws {
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

    let match = TeamDuelWithDraws(teamA: teamA, teamB: teamB, outcome: .win(.sideA))
    let result = UpdateSkill().teamDuelWithDraws(match)

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

  @Test func winVsDrawSkillChange() async throws {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 32, deviation: 3),
      Player(id: "Grace", mean: 29, deviation: 5),
    ])

    let decisiveMatch = TeamDuelWithDraws(teamA: teamA, teamB: teamB, outcome: .win(.sideA))
    let decisiveResult = UpdateSkill().teamDuelWithDraws(decisiveMatch)
    let drawMatch = TeamDuelWithDraws(teamA: teamA, teamB: teamB, outcome: .draw)
    let drawResult = UpdateSkill().teamDuelWithDraws(drawMatch)

    for playerId in ["Alice", "Bob"] {
      let originalPlayer = try #require(teamA.findPlayer(id: playerId))
      let winPlayer = try #require(decisiveResult.findPlayer(id: playerId))
      let drawPlayer = try #require(drawResult.findPlayer(id: playerId))

      let winChange = winPlayer.mean - originalPlayer.mean
      let drawChange = drawPlayer.mean - originalPlayer.mean

      #expect(winChange > 0)
      #expect(drawChange > 0)
      #expect(winChange > drawChange)
    }

    for playerId in ["Frank", "Grace"] {
      let originalPlayer = try #require(teamB.findPlayer(id: playerId))
      let losePlayer = try #require(decisiveResult.findPlayer(id: playerId))
      let drawPlayer = try #require(drawResult.findPlayer(id: playerId))

      let loseChange = losePlayer.mean - originalPlayer.mean
      let drawChange = drawPlayer.mean - originalPlayer.mean

      #expect(loseChange < 0)
      #expect(drawChange < 0)
      #expect(loseChange < drawChange)
    }
  }
}
