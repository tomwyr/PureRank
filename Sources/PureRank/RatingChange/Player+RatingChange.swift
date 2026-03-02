extension Player {
  func getRatingChange(from other: Player) -> PlayerRatingChange {
    .init(mean: other.mean - mean, variance: other.deviation - deviation)
  }
}

struct PlayerRatingChange {
  var mean: Double
  var variance: Double
}
