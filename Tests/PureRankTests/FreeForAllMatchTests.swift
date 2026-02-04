import Testing

@testable import PureRank

@Suite struct FreeForAllTests {
  @Test func playerUpdates() async throws {
    let playerA = Player(id: "Alice", mean: 20, deviation: 8)
    let playerB = Player(id: "Bob", mean: 30, deviation: 6)
    let playerC = Player(id: "Carol", mean: 25, deviation: 7)

    let match = FreeForAllMatch(
      players: [playerA, playerB, playerC],
    )

    let result = UpdateSkill().freeForAllMatch(match)

    func expectPlayer(id: String, mean: Double, deviation: Double) {
      #expect(
        result.hasPlayer(
          id: id,
          mean: mean, meanEpsilon: 0.01,
          deviation: deviation, deviationEpsilon: 0.01
        )
      )
    }

    expectPlayer(id: "Alice", mean: 27.80, deviation: 6.34)
    expectPlayer(id: "Bob", mean: 27.66, deviation: 4.89)
    expectPlayer(id: "Carol", mean: 21.48, deviation: 5.97)
  }

  @Test func uncertaintyDecrease() throws {
    let playerA = Player(id: "Alice", mean: 20, deviation: 8)
    let playerB = Player(id: "Bob", mean: 30, deviation: 6)
    let playerC = Player(id: "Carol", mean: 25, deviation: 7)

    let match = FreeForAllMatch(
      players: [playerA, playerB, playerC],
    )

    let result = UpdateSkill().freeForAllMatch(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    try expectDeviationDecrease(id: "Alice")
    try expectDeviationDecrease(id: "Bob")
    try expectDeviationDecrease(id: "Carol")
  }
}
