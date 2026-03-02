extension Double {
  func approx(_ value: Double, epsilon: Double = 0.01) -> Bool {
    abs(self - value) <= epsilon
  }
}
