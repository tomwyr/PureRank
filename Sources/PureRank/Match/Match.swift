protocol Match: RatingChange {
  associatedtype Competitor: Rating

  var standings: [[Competitor]] { get set }

  mutating func updateRating() -> RatingChangeResult
  func updatingRating() -> Self
}

enum MatchOutcome {
  case win(MatchSide)
  case draw
}

enum MatchSide {
  case sideA, sideB
}
