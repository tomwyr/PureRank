struct TeamDuel: Match {
  var teamA: Team
  var teamB: Team
  var winnerSide: MatchSide

  var standings: [[Team]] {
    get {
      switch winnerSide {
      case .sideA:
        [[teamA], [teamB]]
      case .sideB:
        [[teamB], [teamA]]
      }
    }

    set {
      switch winnerSide {
      case .sideA:
        teamA = newValue[0][0]
        teamB = newValue[1][0]
      case .sideB:
        teamB = newValue[0][0]
        teamA = newValue[1][0]
      }
    }
  }
}

struct TeamDuelWithDraws: Match {
  var teamA: Team
  var teamB: Team
  var outcome: MatchOutcome

  var standings: [[Team]] {
    get {
      switch outcome {
      case .win(.sideA):
        [[teamA], [teamB]]
      case .win(.sideB):
        [[teamB], [teamA]]
      case .draw:
        [[teamA, teamB]]
      }
    }

    set {
      switch outcome {
      case .win(.sideA):
        teamA = newValue[0][0]
        teamB = newValue[1][0]
      case .win(.sideB):
        teamB = newValue[0][0]
        teamA = newValue[1][0]
      case .draw:
        teamA = newValue[0][0]
        teamB = newValue[0][1]
      }
    }
  }
}

struct TeamFreeForAll: Match {
  var teams: [Team]

  var standings: [[Team]] {
    get { teams.map { [$0] } }
    set { teams = newValue.map { $0[0] } }
  }
}

struct TeamFreeForAllWithDraws: Match {
  var teams: [[Team]]

  var standings: [[Team]] {
    get { teams }
    set { teams = newValue }
  }
}
