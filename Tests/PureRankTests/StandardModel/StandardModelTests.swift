import Testing

@testable import PureRank

@Suite struct StandardNormalTests {
  @Test func ppf() {
    func testPpf(_ p: Double, _ range: any RangeExpression<Double>) {
      let result = StandardNormal.ppf(p)
      #expect(range.contains(result))
    }

    testPpf(0.00002, ..<(-3.99))
    testPpf(0.00005, (-3.92)...(-3.86))
    testPpf(0.00015, (-3.63)...(-3.60))
    testPpf(0.00054, (-3.28)...(-3.26))
    testPpf(0.0034, (-2.71)...(-2.70))
    testPpf(0.032, (-1.86)...(-1.85))
    testPpf(0.084, (-1.38)...(-1.37))
    testPpf(0.262, (-0.64)...(-0.63))
    testPpf(0.43, (-0.18)...(-0.17))
    testPpf(0.5, 0...0)
    testPpf(0.56, 0.15...0.16)
    testPpf(0.842, 1.00...1.01)
    testPpf(0.935, 1.51...1.52)
    testPpf(0.985, 2.16...2.18)
    testPpf(0.9955, 2.61...2.62)
    testPpf(0.99943, 3.25...3.26)
    testPpf(0.99985, 3.60...3.63)
    testPpf(0.99995, 3.86...3.92)
    testPpf(0.99999, 3.99...)
  }
}
