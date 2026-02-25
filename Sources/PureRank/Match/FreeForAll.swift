struct FreeForAll: Match {
  var players: [Player]

  var standings: [[Player]] {
    get { players.map { [$0] } }
    set { players = newValue.map { $0[0] } }
  }
}

struct FreeForAllWithDraws: Match {
  var players: [[Player]]

  var standings: [[Player]] {
    get { players }
    set { players = newValue }
  }
}
