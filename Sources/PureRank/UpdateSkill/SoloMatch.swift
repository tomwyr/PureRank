extension UpdateSkill {
  func soloMatch(_ match: SoloMatch) -> SoloMatch {
    let (winner, loser) =
      switch match.winnerSide {
      case .sideA: (match.playerA, match.playerB)
      case .sideB: (match.playerB, match.playerA)
      }

    let params = calcUpdateParams(winner: winner, loser: loser)
    let winnerNew = updatePlayer(winner, params, .win)
    let loserNew = updatePlayer(loser, params, .lose)

    let (playerANew, playerBNew) =
      switch match.winnerSide {
      case .sideA: (winnerNew, loserNew)
      case .sideB: (loserNew, winnerNew)
      }

    return SoloMatch(playerA: playerANew, playerB: playerBNew, winnerSide: match.winnerSide)
  }
}
