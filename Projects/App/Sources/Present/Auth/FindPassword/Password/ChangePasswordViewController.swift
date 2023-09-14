import UIKit
import DesignSystem

final class ChangePasswordViewController: BaseVC<ChangePasswordViewModel>, InputPasswordComponentProtocol {
    let component = InputPasswordComponent()
    
    private func checkPassword() {
        let password = component.inputPasswordTextField.text!
        let checkPassword = component.checkPasswordTextField.text!
        
        if password.elementsEqual(checkPassword) {
            if self.viewModel.isValidPassword(password: password){
                viewModel.requestToChangePassword(password: password) { [ weak self] result in
                    switch result {
                    case .success:
                        self?.viewModel.popToRootVC()
                    case .failure:
                        self?.component.warningLabel.show(warning: "*비밀번호 변경에 실패했습니다.")
                    }
                }
            } else {
                self.component.warningLabel.show(warning: "*비밀번호 형식이 올바르지 않아요.")
            }
        } else {
            self.component.warningLabel.show(warning: "*비밀번호가 일치하지 않아요.")
        }
        LoadingIndicator.hideLoading()
    }
    
    override func configureVC() {
        component.delegate = self
        
        component.passwordLabel.text = "새로운 비밀번호"
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

extension ChangePasswordViewController {
    func nextButtonDidTap(password: String) {
        checkPassword()
    }
}
