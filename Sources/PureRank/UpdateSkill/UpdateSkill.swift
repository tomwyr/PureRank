import Foundation

struct UpdateSkill {
  let matchDeviationRate: Double
  let matchDrawRate: Double

  init(
    matchVarianceFactor: Double = defaultMatchVarianceFactor,
    matchDrawRate: Double = defaultMatchDrawRate,
  ) {
    self.matchDeviationRate = matchVarianceFactor
    self.matchDrawRate = matchDrawRate
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

  func calcUpdateParams(
    wMean: Double, wVariance: Double,
    lMean: Double, lVariance: Double,
    playerCount: Int,
  ) -> MatchUpdateParams {
    let c = calcC(varianceA: wVariance, varianceB: lVariance, playerCount: playerCount)
    let t = (wMean - lMean) / c
    let vt = StandardNormal.pdf(t) / StandardNormal.cdf(t)
    let wt = vt * (vt + t)
    return MatchUpdateParams(c: c, vt: vt, wt: wt)
  }

  func calcDrawUpdateParams(playerA: Player, playerB: Player) -> MatchUpdateParams {
    calcDrawUpdateParams(
      aMean: playerA.mean, aVariance: playerA.variance,
      bMean: playerB.mean, bVariance: playerB.variance,
      playerCount: 2,
    )
  }

  func calcDrawUpdateParams(
    aMean: Double, aVariance: Double,
    bMean: Double, bVariance: Double,
    playerCount: Int,
  ) -> MatchUpdateParams {
    let e = calcDrawMargin()
    let c = calcC(varianceA: aVariance, varianceB: bVariance, playerCount: playerCount)
    let t = (aMean - bMean) / c
    let vt =
      (StandardNormal.pdf(-e - t) - StandardNormal.pdf(e - t))
      / (StandardNormal.cdf(e - t) - StandardNormal.cdf(-e - t))
    let wt =
      pow(vt, 2) + ((e - t) * StandardNormal.pdf(e - t) - (-e - t) * StandardNormal.pdf(-e - t))
      / (StandardNormal.cdf(e - t) - StandardNormal.cdf(-e - t))
    return MatchUpdateParams(c: c, vt: vt, wt: wt)
  }

  func calcC(varianceA: Double, varianceB: Double, playerCount: Int) -> Double {
    sqrt(varianceA + varianceB + Double(playerCount) * pow(matchDeviationRate, 2))
  }

  func calcDrawMargin() -> Double {
    StandardNormal.ppf((1 + matchDrawRate) / 2) * sqrt(2) * matchDeviationRate
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
  case plus = 1
  case minus = -1
}
