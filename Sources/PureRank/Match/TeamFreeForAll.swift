struct TeamFreeForAll: TeamMatch {
  var teams: [Team]

  var standings: [[Team]] {
    get { teams.map { [$0] } }
    set { teams = newValue.map { $0[0] } }
  }
}

struct TeamFreeForAllWithDraws: TeamMatch {
  var teams: [[Team]]

  var standings: [[Team]] {
    get { teams }
    set { teams = newValue }
  }
}
