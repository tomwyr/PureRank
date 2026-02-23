import Foundation

struct Player {
  var id: String
  var mean: Double
  var deviation: Double

  var variance: Double { pow(deviation, 2) }
  var rating: Double { mean - 3 * deviation }

  mutating func updateRating(
    c: Double, v: Double, w: Double,
    delta: MatchUpdateDelta,
  ) {
    let perfVariance = pow(c, 2)
    let ratingVariance = pow(deviation, 2)

    let meanNew = mean + (ratingVariance / c * v) * delta.rawValue
    let deviationNew = sqrt(ratingVariance * (1 - (ratingVariance / perfVariance * w)))

    mean = meanNew
    deviation = deviationNew
  }
}
