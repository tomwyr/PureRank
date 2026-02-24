import Foundation

let matchDeviationRate: Double = 25.0 / 6.0
let matchDrawRate: Double = 0.1

func calcDrawMargin() -> Double {
  stdPpf((1 + matchDrawRate) / 2) * sqrt(2) * matchDeviationRate
}

func calcC(varianceA: Double, varianceB: Double, playerCount: Int) -> Double {
  sqrt(varianceA + varianceB + Double(playerCount) * pow(matchDeviationRate, 2))
}
