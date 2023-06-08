import UIKit
import Shared

class ChangePasswordViewController: BaseVC<ChangePasswordViewModel>, InputPasswordComponentProtocol {
    let component = InputPasswordComponent()
    
    var phoneNumber: String?
    
    init(viewModel: ChangePasswordViewModel, phoneNumber: String) {
        super.init(viewModel: viewModel)
        self.phoneNumber = phoneNumber
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func checkPassword() {
        guard let password = component.inputPasswordTextField.text else { return }
        guard let checkPassword = component.checkPasswordTextField.text else { return }
        
        if password.elementsEqual(checkPassword) {
            if self.viewModel.isValidPassword(password: password){
                viewModel.requestToChangePassword(phoneNumber: phoneNumber!, password: password) { [ weak self] result in
                    switch result {
                    case .success:
                        self?.viewModel.popToRoot()
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
