import Foundation

protocol Match {
  var standings: [[Player]] { get set }

  func updatingRating() -> Self
  mutating func updateRating()
}

extension Match {
  func updatingRating() -> Self {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    let standingCount = standings.joined().count

    for i in 0..<(standingCount - 1) {
      let (iCurrentRank, iCurrentPlayer) = standings.indices(ofFlatIndex: i)
      let (iNextRank, iNextPlayer) = standings.indices(ofFlatIndex: i + 1)

      var current = standings[iCurrentRank][iCurrentPlayer]
      var next = standings[iNextRank][iNextPlayer]

      if iCurrentRank == iNextRank {
        updateRatingDraw(playerA: &current, playerB: &next)
      } else {
        updateRatingWin(winner: &current, loser: &next)
      }

      standings[iCurrentRank][iCurrentPlayer] = current
      standings[iNextRank][iNextPlayer] = next
    }
  }

  func updateRatingWin(winner: inout Player, loser: inout Player) {
    let (wMean, wVariance) = (winner.mean, winner.variance)
    let (lMean, lVariance) = (loser.mean, loser.variance)

    let c = calcC(varianceA: wVariance, varianceB: lVariance, playerCount: 2)
    let t = (wMean - lMean) / c
    let v = stdPdf(t) / stdCdf(t)
    let w = v * (v + t)

    winner.updateRating(c: c, v: v, w: w, delta: .plus)
    loser.updateRating(c: c, v: v, w: w, delta: .minus)
  }

  func updateRatingDraw(playerA: inout Player, playerB: inout Player) {
    let (aMean, aVariance) = (playerA.mean, playerA.variance)
    let (bMean, bVariance) = (playerB.mean, playerB.variance)

    let e = calcDrawMargin()
    let c = calcC(varianceA: aVariance, varianceB: bVariance, playerCount: 2)
    let t = (aMean - bMean) / c
    let v = (stdPdf(-e - t) - stdPdf(e - t)) / (stdCdf(e - t) - stdCdf(-e - t))
    let w =
      pow(v, 2)
      + ((e - t) * stdPdf(e - t) - (-e - t) * stdPdf(-e - t))
      / (stdCdf(e - t) - stdCdf(-e - t))

    playerA.updateRating(c: c, v: v, w: w, delta: .plus)
    playerB.updateRating(c: c, v: v, w: w, delta: .minus)
  }
}

protocol TeamMatch {
  var standings: [[Team]] { get set }

  func updatingRating() -> Self
  mutating func updateRating()
}

extension TeamMatch {
  func updatingRating() -> Self {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    let standingCount = standings.joined().count

    for i in 0..<(standingCount - 1) {
      let (iCurrentRank, iCurrentPlayer) = standings.indices(ofFlatIndex: i)
      let (iNextRank, iNextPlayer) = standings.indices(ofFlatIndex: i + 1)

      var current = standings[iCurrentRank][iCurrentPlayer]
      var next = standings[iNextRank][iNextPlayer]

      if iCurrentRank == iNextRank {
        updateRatingDraw(teamA: &current, teamB: &next)
      } else {
        updateRatingWin(winner: &current, loser: &next)
      }

      standings[iCurrentRank][iCurrentPlayer] = current
      standings[iNextRank][iNextPlayer] = next
    }
  }

  func updateRatingWin(winner: inout Team, loser: inout Team) {
    let (wMean, wVariance) = (winner.mean, winner.variance)
    let (lMean, lVariance) = (loser.mean, loser.variance)

    let c = calcC(
      varianceA: wVariance, varianceB: lVariance,
      playerCount: winner.players.count + loser.players.count,
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
      playerCount: teamA.players.count + teamB.players.count,
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
