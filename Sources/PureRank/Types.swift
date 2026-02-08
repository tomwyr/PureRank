import Foundation

struct Player {
  let id: String
  let mean: Double
  let deviation: Double

  var variance: Double { pow(deviation, 2) }
  var rating: Double { mean - 3 * deviation }
}

struct Team {
  let players: [Player]

  var mean: Double {
    players.reduce(0.0) { sum, player in sum + player.mean }
  }

  var variance: Double {
    players.reduce(0.0) { sum, player in sum + player.variance }
  }
}

struct Duel {
  let playerA: Player
  let playerB: Player
  let winnerSide: MatchSide
}

struct FreeForAll {
  let players: [Player]
}

struct TeamDuel {
  let teamA: Team
  let teamB: Team
  let winnerSide: MatchSide

  var playerCount: Int {
    teamA.players.count + teamB.players.count
  }
}

struct TeamFreeForAll {
  let teams: [Team]

  var playerCount: Int {
    teams.reduce(0) { sum, team in sum + team.players.count }
  }
}

enum MatchSide {
  case sideA, sideB
}
