import Foundation

struct UpdateSkill {
  let matchVarianceFactor: Double

  init(matchVarianceFactor: Double = defaultMatchVarianceFactor) {
    self.matchVarianceFactor = matchVarianceFactor
  }

  func teamMatch(_ match: TeamMatch) -> TeamMatch {
    let (winner, loser) =
      switch match.winnerSide {
      case .sideA: (match.teamA, match.teamB)
      case .sideB: (match.teamB, match.teamA)
      }

    let params = calcUpdateParams(winner: winner, loser: loser, match.playerCount)
    let winnerNew = updateTeam(winner, params, .win)
    let loserNew = updateTeam(loser, params, .lose)

    let (teamANew, teamBNew) =
      switch match.winnerSide {
      case .sideA: (winnerNew, loserNew)
      case .sideB: (loserNew, winnerNew)
      }

    return TeamMatch(teamA: teamANew, teamB: teamBNew, winnerSide: match.winnerSide)
  }

  private func calcUpdateParams(
    winner: Team, loser: Team,
    _ playerCount: Int,
  ) -> MatchUpdateParams {
    let (wMean, wVariance) = (winner.mean(), winner.variance())
    let (lMean, lVariance) = (loser.mean(), loser.variance())

    let c = sqrt(wVariance + lVariance + Double(playerCount) * pow(matchVarianceFactor, 2))
    let t = (wMean - lMean) / c
    let vt = StandardNormal.pdf(t) / StandardNormal.cdf(t)
    let wt = vt * (vt + t)

    return MatchUpdateParams(c: c, vt: vt, wt: wt)
  }

  private func updateTeam(
    _ team: Team,
    _ params: MatchUpdateParams,
    _ delta: MatchUpdateDelta,
  ) -> Team {
    let players = team.players.map { player in
      let cSq = pow(params.c, 2)
      let varianceSq = pow(player.variance, 2)

      let meanNew = player.mean + (varianceSq / params.c * params.vt) * delta.rawValue
      let varianceNew = sqrt(varianceSq * (1 - (varianceSq / cSq * params.wt)))

      return Player(id: player.id, mean: meanNew, variance: varianceNew)
    }

    return Team(players: players)
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
