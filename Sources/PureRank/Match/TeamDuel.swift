struct TeamDuel: TeamMatch {
  var teamA: Team
  var teamB: Team
  var winnerSide: MatchSide

  var playerCount: Int {
    teamA.players.count + teamB.players.count
  }

  func updatingRating() -> TeamDuel {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    switch winnerSide {
    case .sideA:
      updateRating(winner: &teamA, loser: &teamB)
    case .sideB:
      updateRating(winner: &teamB, loser: &teamA)
    }
  }

  func updateRating(winner: inout Team, loser: inout Team) {
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
}

struct TeamDuelWithDraws: TeamMatch {
  var teamA: Team
  var teamB: Team
  var outcome: MatchOutcome

  var playerCount: Int {
    teamA.players.count + teamB.players.count
  }

  func updatingRating() -> TeamDuelWithDraws {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    switch outcome {
    case .win(.sideA):
      updateRating(winner: &teamA, loser: &teamB)
    case .win(.sideB):
      updateRating(winner: &teamB, loser: &teamA)
    case .draw:
      updateRatingDraw(teamA: &teamA, teamB: &teamB)
    }
  }
}
