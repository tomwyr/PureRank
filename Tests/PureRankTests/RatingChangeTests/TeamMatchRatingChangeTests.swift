import Testing

@testable import PureRank

@Suite struct TeamMatchRatingChangeTests {
  @Test func duel() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 25, deviation: 8),
      Player(id: "Bob", mean: 35, deviation: 3),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 45, deviation: 2),
      Player(id: "Grace", mean: 20, deviation: 7),
    ])

    let previousMatch = TeamDuel(teamA: teamA, teamB: teamB, winner: .sideA)

    let newTeamA = Team(players: [
      Player(id: "Alice", mean: 35, deviation: 6),
      Player(id: "Bob", mean: 25, deviation: 7),
    ])

    let newTeamB = Team(players: [
      Player(id: "Frank", mean: 35, deviation: 5),
      Player(id: "Grace", mean: 30, deviation: 4),
    ])

    let newMatch = TeamDuel(teamA: newTeamA, teamB: newTeamB, winner: .sideA)

    let change = newMatch.getRatingChange(from: previousMatch)

    #expect(change.changeA.playerChanges[0].mean == -10)
    #expect(change.changeA.playerChanges[0].variance == 2)
    #expect(change.changeA.playerChanges[1].mean == 10)
    #expect(change.changeA.playerChanges[1].variance == -4)

    #expect(change.changeB.playerChanges[0].mean == 10)
    #expect(change.changeB.playerChanges[0].variance == -3)
    #expect(change.changeB.playerChanges[1].mean == -10)
    #expect(change.changeB.playerChanges[1].variance == 3)
  }

  @Test func duelWithDraws() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 15, deviation: 6),
      Player(id: "Bob", mean: 50, deviation: 2),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 55, deviation: 1),
      Player(id: "Grace", mean: 10, deviation: 9),
    ])

    let previousMatch = TeamDuelWithDraws(teamA: teamA, teamB: teamB, outcome: .draw)

    let newTeamA = Team(players: [
      Player(id: "Alice", mean: 25, deviation: 4),
      Player(id: "Bob", mean: 40, deviation: 5),
    ])

    let newTeamB = Team(players: [
      Player(id: "Frank", mean: 45, deviation: 3),
      Player(id: "Grace", mean: 20, deviation: 6),
    ])

    let newMatch = TeamDuelWithDraws(teamA: newTeamA, teamB: newTeamB, outcome: .draw)

    let change = newMatch.getRatingChange(from: previousMatch)

    #expect(change.changeA.playerChanges[0].mean == -10)
    #expect(change.changeA.playerChanges[0].variance == 2)
    #expect(change.changeA.playerChanges[1].mean == 10)
    #expect(change.changeA.playerChanges[1].variance == -3)

    #expect(change.changeB.playerChanges[0].mean == 10)
    #expect(change.changeB.playerChanges[0].variance == -2)
    #expect(change.changeB.playerChanges[1].mean == -10)
    #expect(change.changeB.playerChanges[1].variance == 3)
  }

  @Test func freeForAll() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 20, deviation: 8),
      Player(id: "Bob", mean: 45, deviation: 3),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 40, deviation: 4),
      Player(id: "Grace", mean: 30, deviation: 6),
    ])

    let teamC = Team(players: [
      Player(id: "Heidi", mean: 35, deviation: 5),
      Player(id: "Ivan", mean: 25, deviation: 7),
    ])

    let previousMatch = TeamFreeForAll(teams: [teamA, teamB, teamC])

    let newTeamA = Team(players: [
      Player(id: "Alice", mean: 35, deviation: 5),
      Player(id: "Bob", mean: 30, deviation: 7),
    ])

    let newTeamB = Team(players: [
      Player(id: "Frank", mean: 30, deviation: 6),
      Player(id: "Grace", mean: 25, deviation: 4),
    ])

    let newTeamC = Team(players: [
      Player(id: "Heidi", mean: 25, deviation: 6),
      Player(id: "Ivan", mean: 35, deviation: 5),
    ])

    let newMatch = TeamFreeForAll(teams: [newTeamA, newTeamB, newTeamC])

    let changes = newMatch.getRatingChange(from: previousMatch)

    #expect(changes[0].playerChanges[0].mean == -15)
    #expect(changes[0].playerChanges[0].variance == 3)
    #expect(changes[0].playerChanges[1].mean == 15)
    #expect(changes[0].playerChanges[1].variance == -4)

    #expect(changes[1].playerChanges[0].mean == 10)
    #expect(changes[1].playerChanges[0].variance == -2)
    #expect(changes[1].playerChanges[1].mean == 5)
    #expect(changes[1].playerChanges[1].variance == 2)

    #expect(changes[2].playerChanges[0].mean == 10)
    #expect(changes[2].playerChanges[0].variance == -1)
    #expect(changes[2].playerChanges[1].mean == -10)
    #expect(changes[2].playerChanges[1].variance == 2)
  }

  @Test func freeForAllWithDraws() {
    let teamA = Team(players: [
      Player(id: "Alice", mean: 10, deviation: 9),
      Player(id: "Bob", mean: 55, deviation: 1),
    ])

    let teamB = Team(players: [
      Player(id: "Frank", mean: 50, deviation: 2),
      Player(id: "Grace", mean: 15, deviation: 8),
    ])

    let teamC = Team(players: [
      Player(id: "Heidi", mean: 35, deviation: 4),
      Player(id: "Ivan", mean: 25, deviation: 6),
    ])

    let previousMatch = TeamFreeForAllWithDraws(teams: [[teamA, teamB], [teamC]])

    let newTeamA = Team(players: [
      Player(id: "Alice", mean: 25, deviation: 6),
      Player(id: "Bob", mean: 40, deviation: 5),
    ])

    let newTeamB = Team(players: [
      Player(id: "Frank", mean: 40, deviation: 4),
      Player(id: "Grace", mean: 25, deviation: 6),
    ])

    let newTeamC = Team(players: [
      Player(id: "Heidi", mean: 25, deviation: 7),
      Player(id: "Ivan", mean: 35, deviation: 5),
    ])

    let newMatch = TeamFreeForAllWithDraws(teams: [[newTeamA, newTeamB], [newTeamC]])

    let changes = newMatch.getRatingChange(from: previousMatch)

    #expect(changes[0][0].playerChanges[0].mean == -15)
    #expect(changes[0][0].playerChanges[0].variance == 3)
    #expect(changes[0][0].playerChanges[1].mean == 15)
    #expect(changes[0][0].playerChanges[1].variance == -4)

    #expect(changes[0][1].playerChanges[0].mean == 10)
    #expect(changes[0][1].playerChanges[0].variance == -2)
    #expect(changes[0][1].playerChanges[1].mean == -10)
    #expect(changes[0][1].playerChanges[1].variance == 2)

    #expect(changes[1][0].playerChanges[0].mean == 10)
    #expect(changes[1][0].playerChanges[0].variance == -3)
    #expect(changes[1][0].playerChanges[1].mean == -10)
    #expect(changes[1][0].playerChanges[1].variance == 1)
  }
}
