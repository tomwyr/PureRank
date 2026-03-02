protocol RatingChange {
  associatedtype RatingChangeResult

  func getRatingChange(from other: Self) -> RatingChangeResult
}

extension Array where Element: RatingChange {
  func getRatingChange(from other: Self) -> [Element.RatingChangeResult] {
    zip(self, other).map { $0.getRatingChange(from: $1) }
  }
}
