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
    let perfVariance = pow(c, 2)
    let ratingVariance = pow(deviation, 2)

    let meanNew = mean + (ratingVariance / c * v) * delta.rawValue
    let deviationNew = sqrt(ratingVariance * (1 - (ratingVariance / perfVariance * w)))

    mean = meanNew
    deviation = deviationNew
  }
}
