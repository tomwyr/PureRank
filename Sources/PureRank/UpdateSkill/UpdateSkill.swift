import Foundation

struct UpdateSkill {
  let matchVarianceFactor: Double

  init(matchVarianceFactor: Double = defaultMatchVarianceFactor) {
    self.matchVarianceFactor = matchVarianceFactor
  }
}

extension UpdateSkill {
  func calcUpdateParams(winner: Player, loser: Player) -> MatchUpdateParams {
    calcUpdateParams(
      wMean: winner.mean, wVariance: winner.variance,
      lMean: loser.mean, lVariance: loser.variance,
      playerCount: 2,
    )
  }

  func calcUpdateParams(winner: Team, loser: Team) -> MatchUpdateParams {
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
}

extension UpdateSkill {
  func updatePlayer(
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

  func updateTeam(
    _ team: Team,
    _ params: MatchUpdateParams,
    _ delta: MatchUpdateDelta,
  ) -> Team {
    Team(
      players: team.players.map { updatePlayer($0, params, delta) }
    )
  }
}

struct MatchUpdateParams {
  let c: Double
  let vt: Double
  let wt: Double
}

enum MatchUpdateDelta: Double {
  case win = 1
  case lose = -1
}
