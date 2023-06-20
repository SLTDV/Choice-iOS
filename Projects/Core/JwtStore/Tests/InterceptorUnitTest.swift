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
        dateformat.locale = .current
        dateformat.timeZone = TimeZone(secondsFromGMT: 0)
        let expiredTime = dateformat.date(from: "2023-06-20 11:54:27")
        let date = Date().addingTimeInterval(32400)
        print("expiredTime = \(String(describing: expiredTime))")
        print("date = \(date)")
        XCTAssertFalse(expiredTime?.compare(date) == .orderedDescending)
    }
}
