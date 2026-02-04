import Testing

@testable import PureRank

@Suite struct SoloMatchTests {
  @Test func playerUpdates() async throws {
    let playerA = Player(id: "Alice", mean: 30, deviation: 4)
    let playerB = Player(id: "Bob", mean: 28, deviation: 6)

    let match = SoloMatch(
      playerA: playerA,
      playerB: playerB,
      winnerSide: .sideA
    )

    let result = UpdateSkill().soloMatch(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01
        )
      )
    }

    expectPlayer(id: "Alice", mean: 31.14, deviation: 3.77)
    expectPlayer(id: "Bob", mean: 25.42, deviation: 5.21)
  }

  @Test func uncertaintyDecrease() throws {
    let playerA = Player(id: "Alice", mean: 30, deviation: 4)
    let playerB = Player(id: "Bob", mean: 28, deviation: 6)

    let match = SoloMatch(
      playerA: playerA,
      playerB: playerB,
      winnerSide: .sideA
    )

    let result = UpdateSkill().soloMatch(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    try expectDeviationDecrease(id: "Alice")
    try expectDeviationDecrease(id: "Bob")
  }
}
