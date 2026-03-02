import Foundation

protocol Match: RatingChange {
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
      let (iCurrentRank, iCurrentComp) = standings.indices(ofFlatIndex: i)
      let (iNextRank, iNextComp) = standings.indices(ofFlatIndex: i + 1)

      var current = standings[iCurrentRank][iCurrentComp]
      var next = standings[iNextRank][iNextComp]

      if iCurrentRank == iNextRank {
        updateRatingForDraw(compA: &current, compB: &next)
      } else {
        updateRatingForWin(winner: &current, loser: &next)
      }

      standings[iCurrentRank][iCurrentComp] = current
      standings[iNextRank][iNextComp] = next
    }
  }

  private func updateRatingForWin(winner: inout Competitor, loser: inout Competitor) {
    let c = calcMatchC(compA: winner, compB: loser)
    let t = (winner.mean - loser.mean) / c
    let v = stdPdf(t) / stdCdf(t)
    let w = v * (v + t)

    winner.updateRating(c: c, v: v, w: w, delta: .plus)
    loser.updateRating(c: c, v: v, w: w, delta: .minus)
  }

  private func updateRatingForDraw(compA: inout Competitor, compB: inout Competitor) {
    let c = calcMatchC(compA: compA, compB: compB)
    let t = (compA.mean - compB.mean) / c
    let e = calcDrawMargin()
    let v = (stdPdf(-e - t) - stdPdf(e - t)) / (stdCdf(e - t) - stdCdf(-e - t))
    let w =
      pow(v, 2)
      + ((e - t) * stdPdf(e - t) - (-e - t) * stdPdf(-e - t))
      / (stdCdf(e - t) - stdCdf(-e - t))

    compA.updateRating(c: c, v: v, w: w, delta: .plus)
    compB.updateRating(c: c, v: v, w: w, delta: .minus)
  }

  private func calcMatchC(compA: Competitor, compB: Competitor) -> Double {
    calcC(
      varianceA: compA.variance, varianceB: compB.variance,
      playerCount: compA.playerCount + compB.playerCount,
    )
  }
}
