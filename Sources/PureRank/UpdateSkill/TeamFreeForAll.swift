extension UpdateSkill {
  func teamFreeForAll(_ match: TeamFreeForAll) -> TeamFreeForAll {
    let teamCount = match.teams.count
    guard teamCount > 1 else { return match }

    var teamsNew = match.teams
    for i in 0..<(teamCount - 1) {
      let (winner, loser) = (teamsNew[i], teamsNew[i + 1])
      let initial = TeamDuel(teamA: winner, teamB: loser, winnerSide: .sideA)
      let updated = teamDuel(initial)
      teamsNew[i] = updated.teamA
      teamsNew[i + 1] = updated.teamB

    }

    return TeamFreeForAll(teams: teamsNew)
  }

  func teamFreeForAllWithDraws(_ match: TeamFreeForAllWithDraws) -> TeamFreeForAllWithDraws {
    let teamCount = match.teamCount
    guard teamCount > 1 else { return match }

    var teamsNew = match.teams
    for i in 0..<(teamCount - 1) {
      let (iCurrentRank, iCurrentTeam) = match.teams.indices(ofFlatIndex: i)
      let (iNextRank, iNextTeam) = match.teams.indices(ofFlatIndex: i + 1)

      let current = teamsNew[iCurrentRank][iCurrentTeam]
      let next = teamsNew[iNextRank][iNextTeam]
      let currentUpdated: Team
      let nextUpdated: Team

      let draw = iCurrentRank == iNextRank
      if draw {
        let initial = TeamDuelWithDraws(teamA: current, teamB: next, outcome: .draw)
        let updated = teamDuelWithDraws(initial)
        currentUpdated = updated.teamA
        nextUpdated = updated.teamB
      } else {
        let initial = TeamDuel(teamA: current, teamB: next, winnerSide: .sideA)
        let updated = teamDuel(initial)
        currentUpdated = updated.teamA
        nextUpdated = updated.teamB
      }

      teamsNew[iCurrentRank][iCurrentTeam] = currentUpdated
      teamsNew[iNextRank][iNextTeam] = nextUpdated
    }

    return TeamFreeForAllWithDraws(teams: teamsNew)
  }
}
