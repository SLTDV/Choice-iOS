import UIKit
import RxSwift
import RxCocoa

final class UserSecurityInfoViewController: BaseVC<UserSecurityInfoViewModel> {
    private let disposeBag = DisposeBag()
    
    private lazy var restoreFrameYValue = 0.0
    
    private let emailLabel = UILabel().then {
        $0.text = "전화번호"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let inputEmailTextfield = UITextField().then {
        $0.placeholder = "010-"
        $0.backgroundColor = .red
        $0.layer.borderWidth = 1
    }
    
    private let CertificationRequestButton = UIButton().then {
        $0.backgroundColor = .black
    }
    
    private let CertificationNumberTextfield = UITextField().then {
        $0.placeholder = "010-"
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
        $0.backgroundColor = ChoiceAsset.Colors.grayDark.color
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.isHidden = true
        $0.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
    }
    
    private func showWarningLabel(warning: String) {
        DispatchQueue.main.async {
            self.warningLabel.isHidden = false
            self.warningLabel.text = warning
        }
    }
    
    private func signUpButtonDidTap() {
    }
    
    func testEmail(email: String) -> Bool {
        return viewModel.isValidEmail(email: email)
    }
    
    func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
    }
    
    override func configureVC() {
        restoreFrameYValue = self.view.frame.origin.y
        signUpButtonDidTap()
        
        navigationItem.title = "회원가입"
    }
    
    override func addView() {
        view.addSubviews(emailLabel,inputEmailTextfield, CertificationRequestButton,
                         CertificationNumberTextfield, warningLabel, signUpButton)
    }
    
    override func setLayout() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputEmailTextfield.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(26)
            $0.trailing.equalTo(CertificationRequestButton.snp.leading).offset(-10)
        }
        
        CertificationRequestButton.snp.makeConstraints {
            $0.top.equalTo(inputEmailTextfield.snp.top)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo(inputEmailTextfield.snp.width).multipliedBy(0.3)
            $0.height.equalTo(40)
        }
        
        CertificationNumberTextfield.snp.makeConstraints {
            $0.top.equalTo(inputEmailTextfield.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(signUpButton.snp.leading)
            $0.bottom.equalTo(signUpButton.snp.top).offset(-12)
        }
        
        signUpButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(49)
        }
    }
}
