import Testing

@testable import PureRank

@Suite struct PlayerTests {
  @Test func varianceCalculation() {
    let players = [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
    ]

    #expect(players[0].variance == 16)
    #expect(players[1].variance == 36)
    #expect(players[2].variance == 25)
  }

  @Test func ratingCalculation() {
    let players = [
      Player(id: "Alice", mean: 30, deviation: 4),
      Player(id: "Bob", mean: 28, deviation: 6),
      Player(id: "Carol", mean: 26, deviation: 5),
    ]

    #expect(players[0].rating == 18)
    #expect(players[1].rating == 10)
    #expect(players[2].rating == 11)
  }
}
