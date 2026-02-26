protocol Rating {
  var mean: Double { get }
  var variance: Double { get }
  var playerCount: Int { get }

  mutating func updateRating(
    c: Double, v: Double, w: Double,
    delta: RatingUpdateDelta,
  )
}

enum RatingUpdateDelta: Double {
  case plus = 1
  case minus = -1
}
