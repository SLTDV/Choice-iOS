import XCTest

final class UITest_SignIn: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
    }
    
    func test_WhenNonExistentUser_ShowErrorMessage() {
        let inputEmailTextField = app.textFields["전화번호"]
        let inputPasswordTextField = app.secureTextFields["비밀번호"]
        let signInButton = app.buttons["로그인"]
        let warningLabel = app.staticTexts["존재하지 않는 계정입니다."]
        
        inputEmailTextField.tap()
        inputEmailTextField.typeText("00011111111")
        
        inputPasswordTextField.tap()
        inputPasswordTextField.typeText("aaaa1111@")
        
        signInButton.tap()
        
        XCTAssertEqual(warningLabel.label, "존재하지 않는 계정입니다.")
    }
}
