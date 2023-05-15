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
        let dateformat = DateFormatter()
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let expiredTime = dateformat.date(from: "2023-05-15 09:18:27")
        let date = Date().addingTimeInterval(32400)
        print("expiredTime = \(String(describing: expiredTime))")
        print("date = \(date)")
        XCTAssertFalse(expiredTime?.compare(date) == .orderedDescending)
    }
}
