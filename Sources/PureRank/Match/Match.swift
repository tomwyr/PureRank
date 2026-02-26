import Foundation

protocol Match {
  associatedtype Competitor: Rating

  var standings: [[Competitor]] { get set }

  mutating func updateRating()
  func updatingRating() -> Self
}

enum MatchOutcome {
  case win(MatchSide)
  case draw
}

enum MatchSide {
  case sideA, sideB
}

extension Match {
  func updatingRating() -> Self {
    var result = self
    result.updateRating()
    return result
  }
}

extension Match {
  mutating func updateRating() {
    let standingCount = standings.joined().count

    for i in 0..<(standingCount - 1) {
      let (iCurrentRank, iCurrentPlayer) = standings.indices(ofFlatIndex: i)
      let (iNextRank, iNextPlayer) = standings.indices(ofFlatIndex: i + 1)

      var current = standings[iCurrentRank][iCurrentPlayer]
      var next = standings[iNextRank][iNextPlayer]

      if iCurrentRank == iNextRank {
        updateRatingDraw(left: &current, right: &next)
      } else {
        updateRatingWin(winner: &current, loser: &next)
      }

      standings[iCurrentRank][iCurrentPlayer] = current
      standings[iNextRank][iNextPlayer] = next
    }
  }

  private func updateRatingWin(winner: inout Competitor, loser: inout Competitor) {
    let c = calcC(
      varianceA: winner.variance, varianceB: loser.variance,
      playerCount: winner.playerCount + loser.playerCount,
    )
    let t = (winner.mean - loser.mean) / c
    let v = stdPdf(t) / stdCdf(t)
    let w = v * (v + t)

    winner.updateRating(c: c, v: v, w: w, delta: .plus)
    loser.updateRating(c: c, v: v, w: w, delta: .minus)
  }

  private func updateRatingDraw(left: inout Competitor, right: inout Competitor) {
    let c = calcC(
      varianceA: left.variance, varianceB: right.variance,
      playerCount: left.playerCount + right.playerCount,
    )
    let t = (left.mean - right.mean) / c
    let e = calcDrawMargin()
    let v = (stdPdf(-e - t) - stdPdf(e - t)) / (stdCdf(e - t) - stdCdf(-e - t))
    let w =
      pow(v, 2)
      + ((e - t) * stdPdf(e - t) - (-e - t) * stdPdf(-e - t))
      / (stdCdf(e - t) - stdCdf(-e - t))

    left.updateRating(c: c, v: v, w: w, delta: .plus)
    right.updateRating(c: c, v: v, w: w, delta: .minus)
  }
}
