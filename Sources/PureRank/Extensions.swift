extension Array where Element: RandomAccessCollection {
  func indices(ofFlatIndex index: Int) -> (Int, Element.Index) {
    var elementIndex = 0
    for i in self.indices {
      for j in self[i].indices {
        if elementIndex == index {
          return (i, j)
        }
        elementIndex += 1
      }
    }
    fatalError("Cannot map flat index \(index) to 2D indices: index out of bounds")
  }
}
