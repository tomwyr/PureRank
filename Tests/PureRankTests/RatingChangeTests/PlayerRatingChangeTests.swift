import Testing

@testable import PureRank

@Suite struct PlayerRatingChangeTests {
  @Test func differentRatings() {
    let playerA = Player(id: "Alice", mean: 25, deviation: 8)
    let playerB = Player(id: "Bob", mean: 35, deviation: 3)

    let change = playerA.getRatingChange(from: playerB)

    #expect(change.mean == 10)
    #expect(change.variance == -5)
  }

  @Test func sameRatings() {
    let playerA = Player(id: "Alice", mean: 40, deviation: 6)
    let playerB = Player(id: "Bob", mean: 40, deviation: 6)

    let change = playerA.getRatingChange(from: playerB)

    #expect(change.mean == 0)
    #expect(change.variance == 0)
  }

  @Test func reversedRatings() {
    let playerA = Player(id: "Alice", mean: 50, deviation: 2)
    let playerB = Player(id: "Bob", mean: 15, deviation: 9)

    let change = playerA.getRatingChange(from: playerB)

    #expect(change.mean == -35)
    #expect(change.variance == 7)
  }

  @Test func decimalRatings() {
    let playerA = Player(id: "Alice", mean: 25.5, deviation: 8.25)
    let playerB = Player(id: "Bob", mean: 35.75, deviation: 3.125)

    let change = playerA.getRatingChange(from: playerB)

    #expect(change.mean == 10.25)
    #expect(change.variance == -5.125)
  }
}
