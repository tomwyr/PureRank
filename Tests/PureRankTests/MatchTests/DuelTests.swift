import Testing

@testable import PureRank

@Suite struct SoloMatchTests {
  @Test func playerUpdates() async throws {
    let playerA = Player(id: "Alice", mean: 25, deviation: 4)
    let playerB = Player(id: "Bob", mean: 30, deviation: 6)

    let match = Duel(playerA: playerA, playerB: playerB, winnerSide: .sideA)
    let result = UpdateSkill().duel(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01
        )
      )
    }

    expectPlayer(id: "Alice", mean: 27.01, deviation: 3.72)
    expectPlayer(id: "Bob", mean: 25.48, deviation: 5.00)
  }

  @Test func uncertaintyDecrease() throws {
    let playerA = Player(id: "Alice", mean: 25, deviation: 4)
    let playerB = Player(id: "Bob", mean: 30, deviation: 6)

    let match = Duel(playerA: playerA, playerB: playerB, winnerSide: .sideA)
    let result = UpdateSkill().duel(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    try expectDeviationDecrease(id: "Alice")
    try expectDeviationDecrease(id: "Bob")
  }

  @Test func duelWithDrawsPlayerUpdates() async throws {
    let playerA = Player(id: "Alice", mean: 25, deviation: 4)
    let playerB = Player(id: "Bob", mean: 30, deviation: 6)

    let match = DuelWithDraws(playerA: playerA, playerB: playerB, outcome: .draw)
    let result = UpdateSkill().duelWithDraws(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01
        )
      )
    }

    expectPlayer(id: "Alice", mean: 25.77, deviation: 3.68)
    expectPlayer(id: "Bob", mean: 28.27, deviation: 4.85)
  }

  @Test func duelWithDrawsUncertaintyDecrease() throws {
    let playerA = Player(id: "Alice", mean: 25, deviation: 4)
    let playerB = Player(id: "Bob", mean: 30, deviation: 6)

    let match = DuelWithDraws(playerA: playerA, playerB: playerB, outcome: .draw)
    let result = UpdateSkill().duelWithDraws(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    try expectDeviationDecrease(id: "Alice")
    try expectDeviationDecrease(id: "Bob")
  }

  @Test func duelWithDrawsWinPlayerUpdates() async throws {
    let playerA = Player(id: "Alice", mean: 25, deviation: 4)
    let playerB = Player(id: "Bob", mean: 30, deviation: 6)

    let match = DuelWithDraws(playerA: playerA, playerB: playerB, outcome: .win(.sideA))
    let result = UpdateSkill().duelWithDraws(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01
        )
      )
    }

    expectPlayer(id: "Alice", mean: 27.01, deviation: 3.72)
    expectPlayer(id: "Bob", mean: 25.48, deviation: 5.00)
  }

  @Test func winVsDrawSkillChange() async throws {
    let playerA = Player(id: "Alice", mean: 25, deviation: 4)
    let playerB = Player(id: "Bob", mean: 30, deviation: 6)

    let decisiveMatch = DuelWithDraws(playerA: playerA, playerB: playerB, outcome: .win(.sideA))
    let decisiveResult = UpdateSkill().duelWithDraws(decisiveMatch)
    let drawMatch = DuelWithDraws(playerA: playerA, playerB: playerB, outcome: .draw)
    let drawResult = UpdateSkill().duelWithDraws(drawMatch)

    let winPlayerA = try #require(decisiveResult.findPlayer(id: "Alice"))
    let drawPlayerA = try #require(drawResult.findPlayer(id: "Alice"))

    let winChangeA = winPlayerA.mean - playerA.mean
    let drawChangeA = drawPlayerA.mean - playerA.mean

    #expect(winChangeA > 0)
    #expect(drawChangeA > 0)
    #expect(winChangeA > drawChangeA)

    let losePlayerB = try #require(decisiveResult.findPlayer(id: "Bob"))
    let drawPlayerB = try #require(drawResult.findPlayer(id: "Bob"))

    let loseChangeB = losePlayerB.mean - playerB.mean
    let drawChangeB = drawPlayerB.mean - playerB.mean

    #expect(loseChangeB < 0)
    #expect(drawChangeB < 0)
    #expect(loseChangeB < drawChangeB)
  }
}
