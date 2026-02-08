extension UpdateSkill {
  func freeForAll(_ match: FreeForAll) -> FreeForAll {
    let playerCount = match.players.count
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
}
