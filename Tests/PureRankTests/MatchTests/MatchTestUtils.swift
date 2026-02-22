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

extension DuelWithDraws: MatchTestUtils {
  var allPlayers: [Player] {
    [playerA, playerB]
  }
}

extension FreeForAllWithDraws: MatchTestUtils {
  var allPlayers: [Player] {
    players.flatMap { $0 }
  }
}

extension TeamDuel: MatchTestUtils {
  var allPlayers: [Player] {
    teamA.players + teamB.players
  }
}

extension TeamDuelWithDraws: MatchTestUtils {
  var allPlayers: [Player] {
    teamA.players + teamB.players
  }
}

extension TeamFreeForAll: MatchTestUtils {
  var allPlayers: [Player] {
    teams.flatMap(\.players)
  }
}

extension TeamFreeForAllWithDraws: MatchTestUtils {
  var allPlayers: [Player] {
    teams.flatMap { $0.flatMap { $0.players } }
  }
}

extension Team {
  func findPlayer(id: String) -> Player? {
    players.first { $0.id == id }
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
    mean: Double? = nil, meanEpsilon: Double = 0.01,
    deviation: Double? = nil, deviationEpsilon: Double = 0.01,
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
