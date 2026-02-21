extension UpdateSkill {
  func teamDuel(_ match: TeamDuel) -> TeamDuel {
    let (winner, loser) =
      switch match.winnerSide {
      case .sideA: (match.teamA, match.teamB)
      case .sideB: (match.teamB, match.teamA)
      }

    let params = calcUpdateParams(winner: winner, loser: loser)
    let winnerNew = updateTeam(winner, params, .plus)
    let loserNew = updateTeam(loser, params, .minus)

    let (teamANew, teamBNew) =
      switch match.winnerSide {
      case .sideA: (winnerNew, loserNew)
      case .sideB: (loserNew, winnerNew)
      }

    return TeamDuel(teamA: teamANew, teamB: teamBNew, winnerSide: match.winnerSide)
  }

  func teamDuelWithDraws(_ match: TeamDuelWithDraws) -> TeamDuelWithDraws {
    switch match.outcome {
    case .draw:
      let (teamANew, teamBNew) = teamDuelDraw(teamA: match.teamA, teamB: match.teamB)
      return TeamDuelWithDraws(teamA: teamANew, teamB: teamBNew, outcome: .draw)

    case .win(let winnerSide):
      let (winner, loser) =
        switch winnerSide {
        case .sideA: (match.teamA, match.teamB)
        case .sideB: (match.teamB, match.teamA)
        }

      let params = calcUpdateParams(winner: winner, loser: loser)
      let winnerNew = updateTeam(winner, params, .plus)
      let loserNew = updateTeam(loser, params, .minus)

      let (teamANew, teamBNew) =
        switch winnerSide {
        case .sideA: (winnerNew, loserNew)
        case .sideB: (loserNew, winnerNew)
        }

      return TeamDuelWithDraws(teamA: teamANew, teamB: teamBNew, outcome: .win(winnerSide))
    }
  }

  private func teamDuelWin(
    teamA: Team, teamB: Team,
    winnerSide: MatchSide,
  ) -> (winner: Team, loser: Team) {
    switch winnerSide {
    case .sideA:
      let (winnerNew, loserNew) = teamDuelWin(winner: teamA, loser: teamB)
      return (winnerNew, loserNew)
    case .sideB:
      let (winnerNew, loserNew) = teamDuelWin(winner: teamB, loser: teamA)
      return (loserNew, winnerNew)
    }
  }

  private func teamDuelWin(winner: Team, loser: Team) -> (winner: Team, loser: Team) {
    let params = calcUpdateParams(winner: winner, loser: loser)
    let winnerNew = updateTeam(winner, params, .plus)
    let loserNew = updateTeam(loser, params, .minus)
    return (winnerNew, loserNew)
  }

  private func teamDuelDraw(teamA: Team, teamB: Team) -> (teamA: Team, teamB: Team) {
    let params = calcDrawUpdateParams(teamA: teamA, teamB: teamB)
    let teamANew = updateTeam(teamA, params, .plus)
    let teamBNew = updateTeam(teamB, params, .minus)
    return (teamA: teamANew, teamB: teamBNew)
  }
}
