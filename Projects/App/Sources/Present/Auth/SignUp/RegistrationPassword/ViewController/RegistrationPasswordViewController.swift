import UIKit
import RxSwift
import RxCocoa
import Shared

final class RegistrationPasswordViewController: BaseVC<RegistrationPasswordViewModel>, InputPasswordComponentProtocol {
    
    private let component = InputPasswordComponent()
    
    private func checkPassword() {
        guard let password = component.inputPasswordTextField.text else { return }
        guard let checkPassword = component.checkPasswordTextField.text else { return }
        
        if password.elementsEqual(checkPassword) {
            if self.viewModel.isValidPassword(password: password){
                self.viewModel.pushUserProfileInfoVC(password: password)
            } else {
                self.component.warningLabel.show(warning: "*비밀번호 형식이 올바르지 않아요.")
            }
        } else {
            self.component.warningLabel.show(warning: "*비밀번호가 일치하지 않아요.")
        }
        LoadingIndicator.hideLoading()
    }
    
    override func configureVC() {
        navigationItem.title = "회원가입"
        
        component.delegate = self
    }
    
    override func addView() {
        view.addSubview(component)
    }
    
    override func setLayout() {
        component.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension RegistrationPasswordViewController {
    func nextButtonDidTap() {
        LoadingIndicator.showLoading(text: "")
        checkPassword()
    }
}
