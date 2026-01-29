import Foundation

struct Player {
  let id: String
  let mean: Double
  let deviation: Double
}

struct Team {
  let players: [Player]

  func mean() -> Double {
    players.reduce(0.0) { sum, player in sum + player.mean }
  }

  func variance() -> Double {
    players.reduce(0.0) { sum, player in sum + pow(player.deviation, 2) }
  }
}

struct TeamMatch {
  let teamA: Team
  let teamB: Team
  let winnerSide: Side

  var playerCount: Int {
    teamA.players.count + teamB.players.count
  }

  enum Side {
    case sideA, sideB
  }
}
