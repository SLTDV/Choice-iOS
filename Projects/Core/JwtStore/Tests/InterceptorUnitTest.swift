import XCTest
@testable import JwtStore

final class InterceptorUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDate_WhenExpriedToken_returnFalse() {
        let expiredTime = DateFormatter().date(from: "2023-05-08 09:18:27 +0000")
        let date = Date().addingTimeInterval(32400)
        print("expiredTime = \(expiredTime)")
        print("date = \(date)")
        XCTAssertFalse(expiredTime?.compare(date) == .orderedAscending)
    }
}
