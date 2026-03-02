import Testing

@testable import PureRank

@Suite struct MatchUpdateRatingChangeTests {
  @Test func duel() {
    let playerA = Player(id: "Alice", mean: 25, deviation: 8)
    let playerB = Player(id: "Bob", mean: 40, deviation: 3)
    var duel = Duel(playerA: playerA, playerB: playerB, winner: .sideA)

    let change = duel.updateRating()

    #expect(change.changeA.mean.approx(-11.66))
    #expect(change.changeA.variance.approx(2.35))
    #expect(change.changeB.mean.approx(1.64))
    #expect(change.changeB.variance.approx(0.10))
  }

  @Test func duelWithDraws() {
    let playerA = Player(id: "Alice", mean: 15, deviation: 6)
    let playerB = Player(id: "Bob", mean: 50, deviation: 2)
    var duel = DuelWithDraws(playerA: playerA, playerB: playerB, outcome: .draw)

    let change = duel.updateRating()

    #expect(change.changeA.mean.approx(-14.86))
    #expect(change.changeA.variance.approx(1.56))
    #expect(change.changeB.mean.approx(1.65))
    #expect(change.changeB.variance.approx(0.05))
  }

  @Test func freeForAll() {
    let players = [
      Player(id: "Alice", mean: 20, deviation: 8),
      Player(id: "Bob", mean: 45, deviation: 3),
      Player(id: "Carol", mean: 30, deviation: 6),
    ]
    
    
    var match = FreeForAll(players: players)

    let changes = match.updateRating()

    #expect(changes[0].mean.approx(-16.89))
    #expect(changes[0].variance.approx(2.56))
    #expect(changes[1].mean.approx(2.22))
    #expect(changes[1].variance.approx(0.15))
    #expect(changes[2].mean.approx(0.63))
    #expect(changes[2].variance.approx(0.35))
  }

  @Test func freeForAllWithDraws() {
    let playerA = Player(id: "Alice", mean: 20, deviation: 8)
    let playerB = Player(id: "Bob", mean: 22, deviation: 6)
    let playerC = Player(id: "Carol", mean: 25, deviation: 7)
    let playerD = Player(id: "Dave", mean: 28, deviation: 5)

    var match = FreeForAllWithDraws(players: [[playerA], [playerB, playerC], [playerD]])

    let changes = match.updateRating()

    #expect(changes[0][0].mean.approx(-5.02))
    #expect(changes[0][0].variance.approx(1.40))
    #expect(changes[1][0].mean.approx(1.56))
    #expect(changes[1][0].variance.approx(1.19))
    #expect(changes[1][1].mean.approx(-1.73))
    #expect(changes[1][1].variance.approx(2.17))
    #expect(changes[2][0].mean.approx(3.06))
    #expect(changes[2][0].variance.approx(0.53))
  }
}
