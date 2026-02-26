struct Duel: Match {
  var playerA: Player
  var playerB: Player
  var winnerSide: MatchSide

  var standings: [[Player]] {
    get {
      switch winnerSide {
      case .sideA:
        [[playerA], [playerB]]
      case .sideB:
        [[playerB], [playerA]]
      }
    }

    set {
      switch winnerSide {
      case .sideA:
        playerA = newValue[0][0]
        playerB = newValue[1][0]
      case .sideB:
        playerB = newValue[0][0]
        playerA = newValue[1][0]
      }
    }
  }
}

struct DuelWithDraws: Match {
  var playerA: Player
  var playerB: Player
  var outcome: MatchOutcome

  var standings: [[Player]] {
    get {
      switch outcome {
      case .win(.sideA):
        [[playerA], [playerB]]
      case .win(.sideB):
        [[playerB], [playerA]]
      case .draw:
        [[playerA, playerB]]
      }
    }

    set {
      switch outcome {
      case .win(.sideA):
        playerA = newValue[0][0]
        playerB = newValue[1][0]
      case .win(.sideB):
        playerB = newValue[0][0]
        playerA = newValue[1][0]
      case .draw:
        playerA = newValue[0][0]
        playerB = newValue[0][1]
      }
    }
  }
}

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
