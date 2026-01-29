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
    variance: Double? = nil, varianceEpsilon: Double = 0,
  ) -> Bool {
    for player in allPlayers {
      if id != player.id { continue }
      if let mean {
        if abs(mean - player.mean) > meanEpsilon {
          continue
        }
      }
      if let variance {
        if abs(variance - player.variance) > varianceEpsilon {
          continue
        }
      }
      return true
    }
    return false
  }
}
