import Testing

@testable import PureRank

@Suite struct StandardNormalTests {
  @Test func pdf() {
    func testPdf(_ t: Double, _ range: any RangeExpression<Double>) {
      #expect(range.contains(stdPdf(t)))
    }

    testPdf(-3.99, 0.00013...0.00015)
    testPdf(-3.92, 0.00017...0.00019)
    testPdf(-3.63, 0.00053...0.00055)
    testPdf(-3.28, 0.0018...0.0020)
    testPdf(-2.71, 0.0101...0.0103)
    testPdf(-1.86, 0.069...0.071)
    testPdf(-1.38, 0.152...0.154)
    testPdf(-0.64, 0.324...0.326)
    testPdf(-0.18, 0.391...0.393)
    testPdf(0, 0.398...0.399)
    testPdf(0.15, 0.394...0.396)
    testPdf(1.00, 0.241...0.243)
    testPdf(1.51, 0.127...0.129)
    testPdf(2.16, 0.038...0.040)
    testPdf(2.61, 0.013...0.015)
    testPdf(3.25, 0.0019...0.0021)
    testPdf(3.60, 0.00060...0.00062)
    testPdf(3.86, 0.00022...0.00024)
    testPdf(3.99, 0.00013...0.00015)
  }

  @Test func cdf() {
    func testCdf(_ t: Double, _ range: any RangeExpression<Double>) {
      #expect(range.contains(stdCdf(t)))
    }

    testCdf(-3.99, ..<0.00004)
    testCdf(-3.92, 0.00004...0.00006)
    testCdf(-3.63, 0.00014...0.00016)
    testCdf(-3.28, 0.00050...0.00052)
    testCdf(-2.71, 0.0033...0.0035)
    testCdf(-1.86, 0.031...0.033)
    testCdf(-1.38, 0.083...0.085)
    testCdf(-0.64, 0.260...0.262)
    testCdf(-0.18, 0.428...0.430)
    testCdf(0, 0.5...0.5)
    testCdf(0.15, 0.558...0.560)
    testCdf(1.00, 0.840...0.842)
    testCdf(1.51, 0.934...0.936)
    testCdf(2.16, 0.984...0.986)
    testCdf(2.61, 0.995...0.996)
    testCdf(3.25, 0.9994...0.9995)
    testCdf(3.60, 0.9998...0.9999)
    testCdf(3.86, 0.99993...0.99995)
    testCdf(3.99, 0.99996...)
  }

  @Test func ppf() {
    func testPpf(_ p: Double, _ range: any RangeExpression<Double>) {
      #expect(range.contains(stdPpf(p)))
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
