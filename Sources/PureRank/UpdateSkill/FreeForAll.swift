extension UpdateSkill {
  func freeForAll(_ match: FreeForAll) -> FreeForAll {
    let playerCount = match.playerCount
    guard playerCount > 1 else { return match }

    var playersNew = match.players
    for i in 0..<(playerCount - 1) {
      let (winner, loser) = (playersNew[i], playersNew[i + 1])
      let initial = Duel(playerA: winner, playerB: loser, winnerSide: .sideA)
      let updated = duel(initial)
      playersNew[i] = updated.playerA
      playersNew[i + 1] = updated.playerB
    }

    return FreeForAll(players: playersNew)
  }

  func freeForAllWithDraws(_ match: FreeForAllWithDraws) -> FreeForAllWithDraws {
    let playerCount = match.playerCount
    guard playerCount > 1 else { return match }

    var playersNew = match.players
    for i in 0..<(playerCount - 1) {
      let (iCurrentRank, iCurrentPlayer) = match.players.indices(ofFlatIndex: i)
      let (iNextRank, iNextPlayer) = match.players.indices(ofFlatIndex: i + 1)

      let current = playersNew[iCurrentRank][iCurrentPlayer]
      let next = playersNew[iNextRank][iNextPlayer]
      let currentUpdated: Player
      let nextUpdated: Player

      let draw = iCurrentRank == iNextRank
      if draw {
        let initial = DuelWithDraws(playerA: current, playerB: next, outcome: .draw)
        let updated = duelWithDraws(initial)
        currentUpdated = updated.playerA
        nextUpdated = updated.playerB
      } else {
        let initial = Duel(playerA: current, playerB: next, winnerSide: .sideA)
        let updated = duel(initial)
        currentUpdated = updated.playerA
        nextUpdated = updated.playerB
      }

      playersNew[iCurrentRank][iCurrentPlayer] = currentUpdated
      playersNew[iNextRank][iNextPlayer] = nextUpdated
    }

    return FreeForAllWithDraws(players: playersNew)
  }
}
