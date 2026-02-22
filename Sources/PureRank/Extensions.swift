extension Array where Element: RandomAccessCollection, Element.Indices == Range<Int> {
  func indices(ofFlatIndex index: Int) -> (Int, Int) {
    guard let indices = indices(ofFlatIndex: index) else {
      fatalError("Cannot map flat index \(index) to 2D indices: index out of bounds")
    }
    return indices
  }

  func indices(ofFlatIndex index: Int) -> (Int, Int)? {
    var elementIndex = 0
    for i in self.indices {
      for j in self[i].indices {
        if elementIndex == index {
          return (i, j)
        }
        elementIndex += 1
      }
    }
    return nil
  }
}
