struct FreeForAll {
  var players: [Player]

  var playerCount: Int {
    players.count
  }

  func updatingRating() -> FreeForAll {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    guard playerCount > 1 else { return }

    for i in 0..<(playerCount - 1) {
      let (current, next) = (players[i], players[i + 1])
      var duel = Duel(playerA: current, playerB: next, winnerSide: .sideA)
      duel.updateRating()
      players[i] = duel.playerA
      players[i + 1] = duel.playerB
    }
  }
}

struct FreeForAllWithDraws {
  var players: [[Player]]

  var playerCount: Int {
    players.reduce(0) { sum, players in sum + players.count }
  }

  func updatingRating() -> FreeForAllWithDraws {
    var result = self
    result.updateRating()
    return result
  }

  mutating func updateRating() {
    guard playerCount > 1 else { return }

    for i in 0..<(playerCount - 1) {
      let (iCurrentRank, iCurrentPlayer) = players.indices(ofFlatIndex: i)
      let (iNextRank, iNextPlayer) = players.indices(ofFlatIndex: i + 1)

      let current = players[iCurrentRank][iCurrentPlayer]
      let next = players[iNextRank][iNextPlayer]
      let currentUpdated: Player
      let nextUpdated: Player

      let draw = iCurrentRank == iNextRank
      if draw {
        var duel = DuelWithDraws(playerA: current, playerB: next, outcome: .draw)
        duel.updateRating()
        currentUpdated = duel.playerA
        nextUpdated = duel.playerB
      } else {
        var duel = Duel(playerA: current, playerB: next, winnerSide: .sideA)
        duel.updateRating()
        currentUpdated = duel.playerA
        nextUpdated = duel.playerB
      }

      players[iCurrentRank][iCurrentPlayer] = currentUpdated
      players[iNextRank][iNextPlayer] = nextUpdated
    }
  }
}
