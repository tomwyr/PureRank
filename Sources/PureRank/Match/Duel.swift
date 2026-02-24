struct Duel: Match {
  var playerA: Player
  var playerB: Player
  var winnerSide: MatchSide

  func updatingRating() -> Duel {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    switch winnerSide {
    case .sideA:
      updateRating(winner: &playerA, loser: &playerB)
    case .sideB:
      updateRating(winner: &playerB, loser: &playerA)
    }
  }
}

struct DuelWithDraws: Match {
  var playerA: Player
  var playerB: Player
  var outcome: MatchOutcome

  func updatingRating() -> DuelWithDraws {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    switch outcome {
    case .win(.sideA):
      updateRating(winner: &playerA, loser: &playerB)
    case .win(.sideB):
      updateRating(winner: &playerB, loser: &playerA)
    case .draw:
      updateRatingDraw(playerA: &playerA, playerB: &playerB)
    }
  }
}
