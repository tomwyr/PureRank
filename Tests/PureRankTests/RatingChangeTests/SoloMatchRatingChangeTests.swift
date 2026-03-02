import Testing

@testable import PureRank

@Suite struct SoloMatchRatingChangeTests {
  @Test func duel() {
    let playerA = Player(id: "Alice", mean: 25, deviation: 8)
    let playerB = Player(id: "Bob", mean: 40, deviation: 3)
    let previousDuel = Duel(playerA: playerA, playerB: playerB, winner: .sideA)

    let newPlayerA = Player(id: "Alice", mean: 35, deviation: 6)
    let newPlayerB = Player(id: "Bob", mean: 30, deviation: 7)
    let newDuel = Duel(playerA: newPlayerA, playerB: newPlayerB, winner: .sideA)

    let change = newDuel.getRatingChange(from: previousDuel)

    #expect(change.changeA.mean == -10)
    #expect(change.changeA.variance == 2)
    #expect(change.changeB.mean == 10)
    #expect(change.changeB.variance == -4)
  }

  @Test func duelWithDraws() {
    let playerA = Player(id: "Alice", mean: 15, deviation: 6)
    let playerB = Player(id: "Bob", mean: 50, deviation: 2)
    let previousDuel = DuelWithDraws(playerA: playerA, playerB: playerB, outcome: .draw)

    let newPlayerA = Player(id: "Alice", mean: 25, deviation: 4)
    let newPlayerB = Player(id: "Bob", mean: 40, deviation: 5)
    let newDuel = DuelWithDraws(playerA: newPlayerA, playerB: newPlayerB, outcome: .draw)

    let change = newDuel.getRatingChange(from: previousDuel)

    #expect(change.changeA.mean == -10)
    #expect(change.changeA.variance == 2)
    #expect(change.changeB.mean == 10)
    #expect(change.changeB.variance == -3)
  }

  @Test func freeForAll() {
    let players = [
      Player(id: "Alice", mean: 20, deviation: 8),
      Player(id: "Bob", mean: 45, deviation: 3),
      Player(id: "Carol", mean: 30, deviation: 6),
    ]
    let previousMatch = FreeForAll(players: players)

    let newPlayers = [
      Player(id: "Alice", mean: 35, deviation: 5),
      Player(id: "Bob", mean: 30, deviation: 7),
      Player(id: "Carol", mean: 25, deviation: 4),
    ]
    let newMatch = FreeForAll(players: newPlayers)

    let changes = newMatch.getRatingChange(from: previousMatch)

    #expect(changes[0].mean == -15)
    #expect(changes[0].variance == 3)
    #expect(changes[1].mean == 15)
    #expect(changes[1].variance == -4)
    #expect(changes[2].mean == 5)
    #expect(changes[2].variance == 2)
  }

  @Test func freeForAllWithDraws() {
    let players = [
      Player(id: "Alice", mean: 10, deviation: 9),
      Player(id: "Bob", mean: 55, deviation: 1),
      Player(id: "Carol", mean: 35, deviation: 4),
    ]
    let previousMatch = FreeForAllWithDraws(players: [[players[0], players[1]], [players[2]]])

    let newPlayers = [
      Player(id: "Alice", mean: 25, deviation: 6),
      Player(id: "Bob", mean: 40, deviation: 5),
      Player(id: "Carol", mean: 25, deviation: 7),
    ]
    let newMatch = FreeForAllWithDraws(players: [[newPlayers[0], newPlayers[1]], [newPlayers[2]]])

    let changes = newMatch.getRatingChange(from: previousMatch)

    #expect(changes[0][0].mean == -15)
    #expect(changes[0][0].variance == 3)
    #expect(changes[0][1].mean == 15)
    #expect(changes[0][1].variance == -4)
    #expect(changes[1][0].mean == 10)
    #expect(changes[1][0].variance == -3)
  }
}
