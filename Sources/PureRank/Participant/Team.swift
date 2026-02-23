struct Team {
  var players: [Player]

  var mean: Double {
    players.reduce(0.0) { sum, player in sum + player.mean }
  }

  var variance: Double {
    players.reduce(0.0) { sum, player in sum + player.variance }
  }

  mutating func updateRating(
    c: Double, v: Double, w: Double,
    delta: MatchUpdateDelta,
  ) {
    for index in players.indices {
      players[index].updateRating(c: c, v: v, w: w, delta: delta)
    }
  }
}
