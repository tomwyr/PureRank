extension UpdateSkill {
  func duel(_ match: Duel) -> Duel {
    let (playerANew, playerBNew) = duelWin(
      playerA: match.playerA, playerB: match.playerB,
      winnerSide: match.winnerSide,
    )
    return Duel(playerA: playerANew, playerB: playerBNew, winnerSide: match.winnerSide)
  }

  func duelWithDraws(_ match: DuelWithDraws) -> DuelWithDraws {
    switch match.outcome {
    case .draw:
      let (playerANew, playerBNew) = duelDraw(playerA: match.playerA, playerB: match.playerB)
      return DuelWithDraws(playerA: playerANew, playerB: playerBNew, outcome: .draw)

    case .win(let winnerSide):
      let (playerANew, playerBNew) = duelWin(
        playerA: match.playerA, playerB: match.playerB,
        winnerSide: winnerSide,
      )
      return DuelWithDraws(playerA: playerANew, playerB: playerBNew, outcome: .win(winnerSide))
    }
  }

  private func duelWin(
    playerA: Player, playerB: Player,
    winnerSide: MatchSide,
  ) -> (winner: Player, loser: Player) {
    switch winnerSide {
    case .sideA:
      let (winnerNew, loserNew) = duelWin(winner: playerA, loser: playerB)
      return (winnerNew, loserNew)
    case .sideB:
      let (winnerNew, loserNew) = duelWin(winner: playerB, loser: playerA)
      return (loserNew, winnerNew)
    }
  }

  private func duelWin(winner: Player, loser: Player) -> (winner: Player, loser: Player) {
    let params = calcUpdateParams(winner: winner, loser: loser)
    let winnerNew = updatePlayer(winner, params, .plus)
    let loserNew = updatePlayer(loser, params, .minus)
    return (winnerNew, loserNew)
  }

  private func duelDraw(playerA: Player, playerB: Player) -> (playerA: Player, playerB: Player) {
    let params = calcDrawUpdateParams(playerA: playerA, playerB: playerB)
    let playerANew = updatePlayer(playerA, params, .plus)
    let playerBNew = updatePlayer(playerB, params, .minus)
    return (playerA: playerANew, playerB: playerBNew)
  }
}
