struct TeamFreeForAll {
  var teams: [Team]

  var teamCount: Int { teams.count }

  var playerCount: Int {
    teams.reduce(0) { sum, team in sum + team.players.count }
  }

  func updatingRating() -> TeamFreeForAll {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    guard teamCount > 1 else { return }

    for i in 0..<(teamCount - 1) {
      let (current, next) = (teams[i], teams[i + 1])
      var duel = TeamDuel(teamA: current, teamB: next, winnerSide: .sideA)
      duel.updateRating()
      teams[i] = duel.teamA
      teams[i + 1] = duel.teamB
    }
  }
}

struct TeamFreeForAllWithDraws {
  var teams: [[Team]]

  var teamCount: Int {
    teams.reduce(0) { sum, teams in sum + teams.count }
  }

  func updatingRating() -> TeamFreeForAllWithDraws {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    guard teamCount > 1 else { return }

    for i in 0..<(teamCount - 1) {
      let (iCurrentRank, iCurrentTeam) = teams.indices(ofFlatIndex: i)
      let (iNextRank, iNextTeam) = teams.indices(ofFlatIndex: i + 1)

      let current = teams[iCurrentRank][iCurrentTeam]
      let next = teams[iNextRank][iNextTeam]
      let currentUpdated: Team
      let nextUpdated: Team

      let draw = iCurrentRank == iNextRank
      if draw {
        var duel = TeamDuelWithDraws(teamA: current, teamB: next, outcome: .draw)
        duel.updateRating()
        currentUpdated = duel.teamA
        nextUpdated = duel.teamB
      } else {
        var duel = TeamDuel(teamA: current, teamB: next, winnerSide: .sideA)
        duel.updateRating()
        currentUpdated = duel.teamA
        nextUpdated = duel.teamB
      }

      teams[iCurrentRank][iCurrentTeam] = currentUpdated
      teams[iNextRank][iNextTeam] = nextUpdated
    }
  }
}
