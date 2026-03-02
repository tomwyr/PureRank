extension Duel {
  func getRatingChange(from previousValue: Duel) -> DuelRatingChange {
    .init(
      changeA: playerA.getRatingChange(from: previousValue.playerA),
      changeB: playerB.getRatingChange(from: previousValue.playerB),
    )
  }
}

extension DuelWithDraws {
  func getRatingChange(from previousValue: DuelWithDraws) -> DuelRatingChange {
    .init(
      changeA: playerA.getRatingChange(from: previousValue.playerA),
      changeB: playerB.getRatingChange(from: previousValue.playerB),
    )
  }
}

extension FreeForAll {
  func getRatingChange(from previousValue: FreeForAll) -> [PlayerRatingChange] {
    players.getRatingChange(from: previousValue.players)
  }
}

extension FreeForAllWithDraws {
  func getRatingChange(from previousValue: FreeForAllWithDraws) -> [[PlayerRatingChange]] {
    zip(players, previousValue.players).map { $0.getRatingChange(from: $1) }
  }
}

struct DuelRatingChange {
  let changeA: PlayerRatingChange
  let changeB: PlayerRatingChange
}
