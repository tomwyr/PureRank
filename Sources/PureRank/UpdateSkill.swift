import Foundation

struct UpdateSkill {
  let matchVarianceFactor: Double

  init(matchVarianceFactor: Double = defaultMatchVarianceFactor) {
    self.matchVarianceFactor = matchVarianceFactor
  }

  func soloMatch(_ match: SoloMatch) -> SoloMatch {
    let (winner, loser) =
      switch match.winnerSide {
      case .sideA: (match.playerA, match.playerB)
      case .sideB: (match.playerB, match.playerA)
      }

    let params = calcUpdateParams(winner: winner, loser: loser)
    let winnerNew = updatePlayer(winner, params, .win)
    let loserNew = updatePlayer(loser, params, .lose)

    let (playerANew, playerBNew) =
      switch match.winnerSide {
      case .sideA: (winnerNew, loserNew)
      case .sideB: (loserNew, winnerNew)
      }

    return SoloMatch(playerA: playerANew, playerB: playerBNew, winnerSide: match.winnerSide)
  }

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

  private func calcUpdateParams(winner: Player, loser: Player) -> MatchUpdateParams {
    calcUpdateParams(
      wMean: winner.mean, wVariance: winner.variance,
      lMean: loser.mean, lVariance: loser.variance,
      playerCount: 2,
    )
  }

  private func calcUpdateParams(winner: Team, loser: Team) -> MatchUpdateParams {
    calcUpdateParams(
      wMean: winner.mean, wVariance: winner.variance,
      lMean: loser.mean, lVariance: loser.variance,
      playerCount: winner.players.count + loser.players.count,
    )
  }

  private func calcUpdateParams(
    wMean: Double, wVariance: Double,
    lMean: Double, lVariance: Double,
    playerCount: Int,
  ) -> MatchUpdateParams {
    let c = sqrt(wVariance + lVariance + Double(playerCount) * pow(matchVarianceFactor, 2))
    let t = (wMean - lMean) / c
    let vt = StandardNormal.pdf(t) / StandardNormal.cdf(t)
    let wt = vt * (vt + t)
    return MatchUpdateParams(c: c, vt: vt, wt: wt)
  }

  private func updatePlayer(
    _ player: Player,
    _ params: MatchUpdateParams,
    _ delta: MatchUpdateDelta,
  ) -> Player {
    let perfVariance = pow(params.c, 2)
    let variance = pow(player.deviation, 2)

    let meanNew = player.mean + (variance / params.c * params.vt) * delta.rawValue
    let deviationNew = sqrt(variance * (1 - (variance / perfVariance * params.wt)))

    return Player(id: player.id, mean: meanNew, deviation: deviationNew)
  }

  private func updateTeam(
    _ team: Team,
    _ params: MatchUpdateParams,
    _ delta: MatchUpdateDelta,
  ) -> Team {
    Team(
      players: team.players.map { updatePlayer($0, params, delta) }
    )
  }
}

private struct MatchUpdateParams {
  let c: Double
  let vt: Double
  let wt: Double
}

private enum MatchUpdateDelta: Double {
  case win = 1
  case lose = -1
}
