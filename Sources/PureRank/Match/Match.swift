import Foundation

protocol Match {}

extension Match {
  func updateRating(winner: inout Player, loser: inout Player) {
    let (wMean, wVariance) = (winner.mean, winner.variance)
    let (lMean, lVariance) = (loser.mean, loser.variance)

    let c = calcC(varianceA: wVariance, varianceB: lVariance, competitorCount: 2)
    let t = (wMean - lMean) / c
    let v = stdPdf(t) / stdCdf(t)
    let w = v * (v + t)

    winner.updateRating(c: c, v: v, w: w, delta: .plus)
    loser.updateRating(c: c, v: v, w: w, delta: .minus)
  }

  func updateRatingDraw(competitorA: inout Player, competitorB: inout Player) {
    let (aMean, aVariance) = (competitorA.mean, competitorA.variance)
    let (bMean, bVariance) = (competitorB.mean, competitorB.variance)

    let e = calcDrawMargin()
    let c = calcC(varianceA: aVariance, varianceB: bVariance, competitorCount: 2)
    let t = (aMean - bMean) / c
    let v = (stdPdf(-e - t) - stdPdf(e - t)) / (stdCdf(e - t) - stdCdf(-e - t))
    let w =
      pow(v, 2)
      + ((e - t) * stdPdf(e - t) - (-e - t) * stdPdf(-e - t))
      / (stdCdf(e - t) - stdCdf(-e - t))

    competitorA.updateRating(c: c, v: v, w: w, delta: .plus)
    competitorB.updateRating(c: c, v: v, w: w, delta: .minus)
  }
}

protocol TeamMatch {}

extension TeamMatch {
  func updateRating(winner: inout Team, loser: inout Team) {
    let (wMean, wVariance) = (winner.mean, winner.variance)
    let (lMean, lVariance) = (loser.mean, loser.variance)

    let c = calcC(
      varianceA: wVariance, varianceB: lVariance,
      competitorCount: winner.players.count + loser.players.count,
    )
    let t = (wMean - lMean) / c
    let v = stdPdf(t) / stdCdf(t)
    let w = v * (v + t)

    winner.updateRating(c: c, v: v, w: w, delta: .plus)
    loser.updateRating(c: c, v: v, w: w, delta: .minus)
  }

  func updateRatingDraw(teamA: inout Team, teamB: inout Team) {
    let (aMean, aVariance) = (teamA.mean, teamA.variance)
    let (bMean, bVariance) = (teamB.mean, teamB.variance)

    let e = calcDrawMargin()
    let c = calcC(
      varianceA: aVariance, varianceB: bVariance,
      competitorCount: teamA.players.count + teamB.players.count,
    )
    let t = (aMean - bMean) / c
    let v = (stdPdf(-e - t) - stdPdf(e - t)) / (stdCdf(e - t) - stdCdf(-e - t))
    let w =
      pow(v, 2)
      + ((e - t) * stdPdf(e - t) - (-e - t) * stdPdf(-e - t))
      / (stdCdf(e - t) - stdCdf(-e - t))

    teamA.updateRating(c: c, v: v, w: w, delta: .plus)
    teamB.updateRating(c: c, v: v, w: w, delta: .minus)
  }
}
