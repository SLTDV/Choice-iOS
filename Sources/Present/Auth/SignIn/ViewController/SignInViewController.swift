import UIKit
import RxSwift

final class SignInViewController: BaseVC<SignInViewModel> {
    private let titleLabel = UILabel().then {
        $0.text = "Choice"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 28, weight: .medium)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "선택의 고민을 한 번에"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    
    private let inputIdTextField = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "이메일")
    }
    
    private let inputPasswordTextField = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호")
    }
    
    private lazy var signInButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .init(red: 0.89, green: 0.89, blue: 0.89, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(pushMainVCButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let divideLineButton = UIView().then {
        $0.backgroundColor = .init(red: 0.37, green: 0.36, blue: 0.36, alpha: 1)
    }
    
    private lazy var pushSignUpViewButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12)
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(pushSignUpVCButtonDidTap(_:)), for: .touchUpInside)
    }
    
//    private func buttonDidTapEvent() {
//        signInButton.rx.tap
//            .bind(onNext: { [weak self] _ in
//                self?.viewModel.pushMainVC()
//            })
//
//        pushSignUpViewButton.rx.tap
//            .bind(onNext: { [weak self] _ in
//                self?.viewModel.pushSignUpVC()
//            })
//    }
//
//    override func configureVC() {
//
//    }
    
    @objc private func pushMainVCButtonDidTap(_ sender: UIButton) {
        guard let email = inputIdTextField.text else { return }
        guard let password = inputPasswordTextField.text else { return }
        viewModel.callToSignInAPI(email: email, password: password)
//        viewModel.pushMainVC()
    }
    
    @objc private func pushSignUpVCButtonDidTap(_ sender: UIButton) {
        viewModel.pushSignUpVC()
    }
    
    override func addView() {
        view.addSubviews(titleLabel, subTitleLabel, inputIdTextField,
                         inputPasswordTextField, signInButton, divideLineButton, pushSignUpViewButton)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(101)
            $0.leading.equalToSuperview().inset(25)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        inputIdTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(77)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        inputPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(inputIdTextField.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
    
        signInButton.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(52)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(49)
        }
        
        divideLineButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(1)
        }
        
        pushSignUpViewButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(divideLineButton.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(140)
        }
    }
}

