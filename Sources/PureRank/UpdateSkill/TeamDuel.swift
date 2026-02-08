extension UpdateSkill {
  func teamDuel(_ match: TeamDuel) -> TeamDuel {
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

    return TeamDuel(teamA: teamANew, teamB: teamBNew, winnerSide: match.winnerSide)
  }
}
