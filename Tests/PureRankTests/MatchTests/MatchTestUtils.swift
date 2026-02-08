import Foundation

@testable import PureRank

extension Duel: MatchTestUtils {
  var allPlayers: [Player] {
    [playerA, playerB]
  }
}

extension FreeForAll: MatchTestUtils {
  var allPlayers: [Player] {
    players
  }
}

extension TeamDuel: MatchTestUtils {
  var allPlayers: [Player] {
    teamA.players + teamB.players
  }
}

extension TeamFreeForAll: MatchTestUtils {
  var allPlayers: [Player] {
    teams.flatMap(\.players)
  }
}

protocol MatchTestUtils {
  var allPlayers: [Player] { get }
}

extension MatchTestUtils {
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
