import Foundation

struct Player: Rating {
  var id: String
  var mean: Double
  var deviation: Double

  var variance: Double { pow(deviation, 2) }
  var rating: Double { mean - 3 * deviation }

  var playerCount: Int { 1 }

  mutating func updateRating(
    c: Double, v: Double, w: Double,
    delta: RatingUpdateDelta,
  ) {
    mean = mean + (variance / c * v) * delta.rawValue
    deviation = sqrt(variance * (1 - (variance / pow(c, 2) * w)))
  }
}
