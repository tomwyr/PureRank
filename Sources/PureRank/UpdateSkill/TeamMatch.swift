extension UpdateSkill {
  func teamMatch(_ match: TeamMatch) -> TeamMatch {
    let (winner, loser) =
      switch match.winnerSide {
      case .sideA: (match.teamA, match.teamB)
      case .sideB: (match.teamB, match.teamA)
      }

    let params = calcUpdateParams(winner: winner, loser: loser)
    let winnerNew = updateTeam(winner, params, .win)
    let loserNew = updateTeam(loser, params, .lose)

    let (teamANew, teamBNew) =
      switch match.winnerSide {
      case .sideA: (winnerNew, loserNew)
      case .sideB: (loserNew, winnerNew)
      }

    return TeamMatch(teamA: teamANew, teamB: teamBNew, winnerSide: match.winnerSide)
  }
}
