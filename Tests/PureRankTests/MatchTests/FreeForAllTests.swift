import Testing

@testable import PureRank

@Suite struct FreeForAllTests {
  @Test func playerUpdates() async throws {
    let playerA = Player(id: "Alice", mean: 20, deviation: 8)
    let playerB = Player(id: "Bob", mean: 22, deviation: 6)
    let playerC = Player(id: "Carol", mean: 25, deviation: 7)
    let playerD = Player(id: "Dave", mean: 28, deviation: 5)

    let match = FreeForAll(players: [playerA, playerB, playerC, playerD])
    let result = UpdateSkill().freeForAll(match)

    #expect(result.hasPlayer(id: "Alice", mean: 25.02, deviation: 6.60))
    #expect(result.hasPlayer(id: "Bob", mean: 22.44, deviation: 4.88))
    #expect(result.hasPlayer(id: "Carol", mean: 24.51, deviation: 4.89))
    #expect(result.hasPlayer(id: "Dave", mean: 24.31, deviation: 4.44))
  }

  @Test func uncertaintyDecrease() throws {
    let playerA = Player(id: "Alice", mean: 20, deviation: 8)
    let playerB = Player(id: "Bob", mean: 22, deviation: 6)
    let playerC = Player(id: "Carol", mean: 25, deviation: 7)
    let playerD = Player(id: "Dave", mean: 28, deviation: 5)

    let match = FreeForAll(players: [playerA, playerB, playerC, playerD])
    let result = UpdateSkill().freeForAll(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    try expectDeviationDecrease(id: "Alice")
    try expectDeviationDecrease(id: "Bob")
    try expectDeviationDecrease(id: "Carol")
    try expectDeviationDecrease(id: "Dave")
  }

  @Test func freeForAllWithDrawsPlayerUpdates() async throws {
    let playerA = Player(id: "Alice", mean: 20, deviation: 8)
    let playerB = Player(id: "Bob", mean: 22, deviation: 6)
    let playerC = Player(id: "Carol", mean: 25, deviation: 7)
    let playerD = Player(id: "Dave", mean: 28, deviation: 5)

    let match = FreeForAllWithDraws(players: [[playerA], [playerB, playerC], [playerD]])
    let result = UpdateSkill().freeForAllWithDraws(match)

    #expect(result.hasPlayer(id: "Alice", mean: 25.02, deviation: 6.60))
    #expect(result.hasPlayer(id: "Bob", mean: 20.44, deviation: 4.81))
    #expect(result.hasPlayer(id: "Carol", mean: 26.73, deviation: 4.83))
    #expect(result.hasPlayer(id: "Dave", mean: 24.94, deviation: 4.47))
  }

  @Test func freeForAllWithDrawsUncertaintyDecrease() throws {
    let playerA = Player(id: "Alice", mean: 20, deviation: 8)
    let playerB = Player(id: "Bob", mean: 22, deviation: 6)
    let playerC = Player(id: "Carol", mean: 25, deviation: 7)
    let playerD = Player(id: "Dave", mean: 28, deviation: 5)

    let match = FreeForAllWithDraws(players: [[playerA], [playerB, playerC], [playerD]])
    let result = UpdateSkill().freeForAllWithDraws(match)

    func expectDeviationDecrease(id: String) throws {
      let before = try #require(match.findPlayer(id: id))
      let after = try #require(result.findPlayer(id: id))
      #expect(after.deviation < before.deviation)
    }

    try expectDeviationDecrease(id: "Alice")
    try expectDeviationDecrease(id: "Bob")
    try expectDeviationDecrease(id: "Carol")
    try expectDeviationDecrease(id: "Dave")
  }

  @Test func winVsDrawSkillChange() async throws {
    let playerA = Player(id: "Alice", mean: 20, deviation: 8)
    let playerB = Player(id: "Bob", mean: 22, deviation: 6)
    let playerC = Player(id: "Carol", mean: 25, deviation: 7)
    let playerD = Player(id: "Dave", mean: 28, deviation: 5)

    let decisiveMatch = FreeForAllWithDraws(players: [[playerA], [playerB], [playerC], [playerD]])
    let decisiveResult = UpdateSkill().freeForAllWithDraws(decisiveMatch)
    let drawMatch = FreeForAllWithDraws(players: [[playerA], [playerB, playerC], [playerD]])
    let drawResult = UpdateSkill().freeForAllWithDraws(drawMatch)

    let decisivePlayerA = try #require(decisiveResult.findPlayer(id: "Alice"))
    let drawPlayerA = try #require(drawResult.findPlayer(id: "Alice"))

    let decisiveChangeA = decisivePlayerA.mean - playerA.mean
    let drawChangeA = drawPlayerA.mean - playerA.mean

    #expect(decisiveChangeA > 0)
    #expect(drawChangeA > 0)
    #expect(decisiveChangeA == drawChangeA)

    let decisivePlayerB = try #require(decisiveResult.findPlayer(id: "Bob"))
    let drawPlayerB = try #require(drawResult.findPlayer(id: "Bob"))

    let decisiveChangeB = decisivePlayerB.mean - playerB.mean
    let drawChangeB = drawPlayerB.mean - playerB.mean

    #expect(decisiveChangeB > 0)
    #expect(drawChangeB < 0)
    #expect(decisiveChangeB > drawChangeB)

    let decisivePlayerC = try #require(decisiveResult.findPlayer(id: "Carol"))
    let drawPlayerC = try #require(drawResult.findPlayer(id: "Carol"))

    let decisiveChangeC = decisivePlayerC.mean - playerC.mean
    let drawChangeC = drawPlayerC.mean - playerC.mean

    #expect(decisiveChangeC < 0)
    #expect(drawChangeC > 0)
    #expect(decisiveChangeC < drawChangeC)

    let decisivePlayerD = try #require(decisiveResult.findPlayer(id: "Dave"))
    let drawPlayerD = try #require(drawResult.findPlayer(id: "Dave"))

    let decisiveChangeD = decisivePlayerD.mean - playerD.mean
    let drawChangeD = drawPlayerD.mean - playerD.mean

    #expect(decisiveChangeD < 0)
    #expect(drawChangeD < 0)
    #expect(decisiveChangeD < drawChangeD)
  }
}
