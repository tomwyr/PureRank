import Testing

@testable import PureRank

@Suite struct TeamMatchUpdateRatingTests {
  @Test func teamDuel() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 25, deviation: 8),
      Player(id: "Bob", mean: 35, deviation: 3),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 45, deviation: 2),
      Player(id: "Grace", mean: 20, deviation: 7),
    ])

    var match = TeamDuel(teamA: teamA, teamB: teamB, winner: .sideA)

    let change = match.updateRating()

    #expect(change.changeA.playerChanges[0].mean.approx(-4.75))
    #expect(change.changeA.playerChanges[0].variance.approx(0.99))
    #expect(change.changeA.playerChanges[1].mean.approx(-0.67))
    #expect(change.changeA.playerChanges[1].variance.approx(0.05))

    #expect(change.changeB.playerChanges[0].mean.approx(0.30))
    #expect(change.changeB.playerChanges[0].variance.approx(0.01))
    #expect(change.changeB.playerChanges[1].mean.approx(3.64))
    #expect(change.changeB.playerChanges[1].variance.approx(0.65))
  }

  @Test func teamDuelWithDraws() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 15, deviation: 6),
      Player(id: "Bob", mean: 50, deviation: 2),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 30, deviation: 5),
      Player(id: "Grace", mean: 40, deviation: 3),
    ])

    var match = TeamDuelWithDraws(teamA: teamA, teamB: teamB, outcome: .draw)

    let change = match.updateRating()

    #expect(change.changeA.playerChanges[0].mean.approx(-1.04))
    #expect(change.changeA.playerChanges[0].variance.approx(0.66))
    #expect(change.changeA.playerChanges[1].mean.approx(-0.12))
    #expect(change.changeA.playerChanges[1].variance.approx(0.02))

    #expect(change.changeB.playerChanges[0].mean.approx(0.72))
    #expect(change.changeB.playerChanges[0].variance.approx(0.38))
    #expect(change.changeB.playerChanges[1].mean.approx(0.26))
    #expect(change.changeB.playerChanges[1].variance.approx(0.08))
  }

  @Test func teamFreeForAll() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 20, deviation: 8),
      Player(id: "Bob", mean: 22, deviation: 6),
    ])

    let teamB = Team(players: [
      Player(id: "Carol", mean: 25, deviation: 7),
      Player(id: "Dave", mean: 28, deviation: 5),
    ])

    let teamC = Team(players: [
      Player(id: "Eve", mean: 30, deviation: 4),
      Player(id: "Frank", mean: 32, deviation: 6),
    ])

    var match = TeamFreeForAll(teams: [teamA, teamB, teamC])

    let changes = match.updateRating()

    #expect(changes[0].playerChanges[0].mean.approx(-5.31))
    #expect(changes[0].playerChanges[0].variance.approx(0.85))
    #expect(changes[0].playerChanges[1].mean.approx(-2.99))
    #expect(changes[0].playerChanges[1].variance.approx(0.35))

    #expect(changes[1].playerChanges[0].mean.approx(-0.84))
    #expect(changes[1].playerChanges[0].variance.approx(1.17))
    #expect(changes[1].playerChanges[1].mean.approx(-0.65))
    #expect(changes[1].playerChanges[1].variance.approx(0.45))

    #expect(changes[2].playerChanges[0].mean.approx(1.89))
    #expect(changes[2].playerChanges[0].variance.approx(0.14))
    #expect(changes[2].playerChanges[1].mean.approx(4.26))
    #expect(changes[2].playerChanges[1].variance.approx(0.49))
  }

  @Test func teamFreeForAllWithDraws() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 20, deviation: 8),
      Player(id: "Bob", mean: 22, deviation: 6),
    ])

    let teamB = Team(players: [
      Player(id: "Carol", mean: 25, deviation: 7),
      Player(id: "Dave", mean: 28, deviation: 5),
    ])

    let teamC = Team(players: [
      Player(id: "Eve", mean: 30, deviation: 4),
      Player(id: "Frank", mean: 32, deviation: 6),
    ])

    var match = TeamFreeForAllWithDraws(teams: [[teamA], [teamB, teamC]])

    let changes = match.updateRating()

    #expect(changes[0][0].playerChanges[0].mean.approx(-5.31))
    #expect(changes[0][0].playerChanges[0].variance.approx(0.85))
    #expect(changes[0][0].playerChanges[1].mean.approx(-2.99))
    #expect(changes[0][0].playerChanges[1].variance.approx(0.35))

    #expect(changes[1][0].playerChanges[0].mean.approx(1.24))
    #expect(changes[1][0].playerChanges[0].variance.approx(1.20))
    #expect(changes[1][0].playerChanges[1].mean.approx(0.50))
    #expect(changes[1][0].playerChanges[1].variance.approx(0.46))

    #expect(changes[1][1].playerChanges[0].mean.approx(1.09))
    #expect(changes[1][1].playerChanges[0].variance.approx(0.15))
    #expect(changes[1][1].playerChanges[1].mean.approx(2.45))
    #expect(changes[1][1].playerChanges[1].variance.approx(0.51))
  }
}
