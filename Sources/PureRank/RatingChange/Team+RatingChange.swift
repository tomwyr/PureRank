extension Team {
  func getRatingChange(from other: Team) -> TeamRatingChange {
    .init(
      playerChanges: players.getRatingChange(from: other.players),
    )
  }
}

struct TeamRatingChange {
  var playerChanges: [PlayerRatingChange]
}
