
import XCTest
import l10n
import JAYSON
import PathKit

class GenSpec: XCTestCase {

  func testGen() {
    
    print(Path.current)

    let path = Path("./fixtures/sample.json")
    print(try! path.read())

//    let json = JAYSON(data: <#T##Data#>)

//    Generator.gen(json: <#T##JAYSON#>, target: <#T##String#>)
  }
}
