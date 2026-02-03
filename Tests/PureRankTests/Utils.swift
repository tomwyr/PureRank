import Foundation

@testable import PureRank

extension TeamMatch {
  var allPlayers: [Player] {
    teamA.players + teamB.players
  }

  func findPlayer(id: String) -> Player? {
    allPlayers.first { $0.id == id }
  }

  func hasPlayer(
    id: String,
    mean: Double? = nil, meanEpsilon: Double = 0,
    deviation: Double? = nil, deviationEpsilon: Double = 0,
  ) -> Bool {
    for player in allPlayers {
      if id != player.id { continue }
      if let mean {
        if abs(mean - player.mean) > meanEpsilon {
          continue
        }
      }
      if let deviation {
        if abs(deviation - player.deviation) > deviationEpsilon {
          continue
        }
      }
      return true
    }
    return false
  }
}
