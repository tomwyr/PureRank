extension TeamDuel {
  func getRatingChange(from previousValue: TeamDuel) -> TeamDuelRatingChange {
    .init(
      changeA: teamA.getRatingChange(from: previousValue.teamA),
      changeB: teamB.getRatingChange(from: previousValue.teamB),
    )
  }
}

extension TeamDuelWithDraws {
  func getRatingChange(from previousValue: TeamDuelWithDraws) -> TeamDuelRatingChange {
    .init(
      changeA: teamA.getRatingChange(from: previousValue.teamA),
      changeB: teamB.getRatingChange(from: previousValue.teamB),
    )
  }
}

extension TeamFreeForAll {
  func getRatingChange(from previousValue: TeamFreeForAll) -> [TeamRatingChange] {
    teams.getRatingChange(from: previousValue.teams)
  }
}

extension TeamFreeForAllWithDraws {
  func getRatingChange(from previousValue: TeamFreeForAllWithDraws) -> [[TeamRatingChange]] {
    zip(teams, previousValue.teams).map { $0.getRatingChange(from: $1) }
  }
}

struct TeamDuelRatingChange {
  let changeA: TeamRatingChange
  let changeB: TeamRatingChange
}
