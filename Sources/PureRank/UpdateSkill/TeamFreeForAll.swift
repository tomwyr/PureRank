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
}
