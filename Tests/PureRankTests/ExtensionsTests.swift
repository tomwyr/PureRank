import Testing

@testable import PureRank

@Suite struct ArrayExtensionsTests {
  @Test func indicesOfFlatIndex() {
    let array = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ]

    #expect(array.indices(ofFlatIndex: 0) == (0, 0))
    #expect(array.indices(ofFlatIndex: 1) == (0, 1))
    #expect(array.indices(ofFlatIndex: 3) == (1, 0))
    #expect(array.indices(ofFlatIndex: 5) == (1, 2))
    #expect(array.indices(ofFlatIndex: 7) == (2, 1))
    #expect(array.indices(ofFlatIndex: 8) == (2, 2))
  }

  @Test func indicesOfFlatIndexWithEmptyArray() {
    let array = [] as [[Int]]
    #expect(array.indices(ofFlatIndex: 0) == nil)
  }

  @Test func indicesOfFlatIndexWithEmptySubArrays() {
    let array = [[], [], []] as [[Int]]
    #expect(array.indices(ofFlatIndex: 0) == nil)
  }

  @Test func indicesOfFlatIndexOutOfBounds() {
    let array = [
      [1, 2],
      [3, 4],
    ]

    #expect(array.indices(ofFlatIndex: 4) == nil)
    #expect(array.indices(ofFlatIndex: -1) == nil)
  }

  @Test func indicesOfFlatIndexWithNonUniformSubArrays() {
    let array = [
      [1, 2],
      [3, 4, 5],
      [6],
    ]

    #expect(array.indices(ofFlatIndex: 0) == (0, 0))
    #expect(array.indices(ofFlatIndex: 1) == (0, 1))
    #expect(array.indices(ofFlatIndex: 2) == (1, 0))
    #expect(array.indices(ofFlatIndex: 3) == (1, 1))
    #expect(array.indices(ofFlatIndex: 4) == (1, 2))
    #expect(array.indices(ofFlatIndex: 5) == (2, 0))
    #expect(array.indices(ofFlatIndex: 6) == nil)
  }
}
