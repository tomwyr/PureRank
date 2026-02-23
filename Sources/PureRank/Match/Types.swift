enum MatchOutcome {
  case win(MatchSide)
  case draw
}

enum MatchSide {
  case sideA, sideB
}

enum MatchUpdateDelta: Double {
  case plus = 1
  case minus = -1
}
