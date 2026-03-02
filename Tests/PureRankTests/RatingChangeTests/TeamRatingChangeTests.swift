import Testing

@testable import PureRank

@Suite struct TeamRatingChangeTests {
  @Test func differentRatings() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 25, deviation: 8),
      Player(id: "Bob", mean: 35, deviation: 3),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 45, deviation: 2),
      Player(id: "Grace", mean: 20, deviation: 7),
    ])

    let change = teamA.getRatingChange(from: teamB)

    #expect(change.playerChanges[0].mean == 20)
    #expect(change.playerChanges[0].variance == -6)
    #expect(change.playerChanges[1].mean == -15)
    #expect(change.playerChanges[1].variance == 4)
  }

  @Test func sameRatings() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 30, deviation: 5),
      Player(id: "Bob", mean: 40, deviation: 4),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 30, deviation: 5),
      Player(id: "Grace", mean: 40, deviation: 4),
    ])

    let change = teamA.getRatingChange(from: teamB)

    #expect(change.playerChanges[0].mean == 0)
    #expect(change.playerChanges[0].variance == 0)
    #expect(change.playerChanges[1].mean == 0)
    #expect(change.playerChanges[1].variance == 0)
  }

  @Test func reversedRatings() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 40, deviation: 4),
      Player(id: "Bob", mean: 35, deviation: 8),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 30, deviation: 6),
      Player(id: "Grace", mean: 40, deviation: 5),
    ])

    let change = teamA.getRatingChange(from: teamB)

    #expect(change.playerChanges[0].mean == -10)
    #expect(change.playerChanges[0].variance == 2)
    #expect(change.playerChanges[1].mean == 5)
    #expect(change.playerChanges[1].variance == -3)
  }

  @Test func decimalRatings() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 25.5, deviation: 8.25),
      Player(id: "Bob", mean: 35.75, deviation: 3.125),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 45.25, deviation: 2.5),
      Player(id: "Grace", mean: 20.75, deviation: 7.25),
    ])

    let change = teamA.getRatingChange(from: teamB)

    #expect(change.playerChanges[0].mean == 19.75)
    #expect(change.playerChanges[0].variance == -5.75)
    #expect(change.playerChanges[1].mean == -15.0)
    #expect(change.playerChanges[1].variance == 4.125)
  }
}
