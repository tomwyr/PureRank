import Foundation

struct StandardNormal {
  /// Calculates standard normal probability density function φ(t) (PDF)
  static func pdf(_ t: Double) -> Double {
    exp(-0.5 * pow(t, 2)) / sqrt(2 * .pi)
  }

  /// Calculates standard normal cumulative distribution function Φ(t) (CDF)
  static func cdf(_ t: Double) -> Double {
    0.5 * (1 + erf(t / sqrt(2)))
  }
}
