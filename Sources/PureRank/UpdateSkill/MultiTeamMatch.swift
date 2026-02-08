extension UpdateSkill {
  func multiTeamMatch(_ match: MultiTeamMatch) -> MultiTeamMatch {
    let teamCount = match.teams.count
    guard teamCount > 1 else { return match }

    var teamsNew = match.teams
    for i in 0..<(teamCount - 1) {
      let (winner, loser) = (teamsNew[i], teamsNew[i + 1])
      let initial = TeamMatch(teamA: winner, teamB: loser, winnerSide: .sideA)
      let updated = teamMatch(initial)
      teamsNew[i] = updated.teamA
      teamsNew[i + 1] = updated.teamB

    }

    return MultiTeamMatch(teams: teamsNew)
  }
}
