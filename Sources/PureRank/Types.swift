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

struct SoloMatch {
  let playerA: Player
  let playerB: Player
  let winnerSide: MatchSide
}

struct FreeForAllMatch {
  let players: [Player]
}

struct TeamMatch {
  let teamA: Team
  let teamB: Team
  let winnerSide: MatchSide

  var playerCount: Int {
    teamA.players.count + teamB.players.count
  }
}

enum MatchSide {
  case sideA, sideB
}
