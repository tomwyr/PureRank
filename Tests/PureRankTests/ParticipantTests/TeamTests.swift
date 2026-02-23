import Testing

@testable import PureRank

@Suite struct TeamTests {
  @Test func meanCalculation() {
    let players = [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
    ]

    let team = Team(players: players)

    #expect(team.mean == 84)
  }

  @Test func varianceCalculation() {
    let players = [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
    ]

    let team = Team(players: players)

    #expect(team.variance == 77)
  }
}
