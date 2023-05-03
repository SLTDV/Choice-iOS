import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseVC<SignInViewModel> {    
    private let disposeBag = DisposeBag()
    
    private let titleImageView = UIImageView().then {
        $0.image = ChoiceAsset.Images.homeLogo.image
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "선택의 고민을 한 번에"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 16, weight: .light)
    }
    
    private let inputIdTextField = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "휴대폰 번호")
        $0.keyboardType = .numberPad
    }
    
    private let inputPasswordTextField = UnderLineTextField().then {
        $0.setPlaceholder(placeholder: "비밀번호")
        $0.isSecureTextEntry = true
    }
    
    private lazy var signInButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    private let divideLineButton = UIView().then {
        $0.backgroundColor = .init(red: 0.37, green: 0.36, blue: 0.36, alpha: 1)
    }
    
    private lazy var pushSignUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12)
        $0.backgroundColor = .white
    }
    
    private let warningLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.isHidden = true
        $0.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
    }
    
    private func showWarningLabel(warning: String) {
        DispatchQueue.main.async {
            self.warningLabel.isHidden = false
            self.warningLabel.text = warning
        }
    }
    
    private func bind() {
        signInButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let email = self?.inputIdTextField.text else { return }
                guard let password = self?.inputPasswordTextField.text else { return }
                
                LoadingIndicator.showLoading(text: "")
                DispatchQueue.main.async {
                    self?.viewModel.requestSignIn(email: email, password: password){ [weak self] isComplete in
                        guard isComplete else {
                            self?.showWarningLabel(warning: "아이디 또는 비밀번호가 잘못되었습니다.")
                           
                            DispatchQueue.main.async {
                                self?.inputIdTextField.shake()
                                self?.inputPasswordTextField.shake()
                            }
                            return
                        }
                    }
                }
            }).disposed(by: disposeBag)
        
        pushSignUpButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.pushSignUpVC()
            }).disposed(by: disposeBag)
    }
    
    override func configureVC() {
        bind()
    }
    
    override func addView() {
        view.addSubviews(titleImageView, subTitleLabel, inputIdTextField, inputPasswordTextField,
                         signInButton, divideLineButton, pushSignUpButton, warningLabel)
    }
    
    override func setLayout() {
        titleImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(101)
            $0.leading.equalToSuperview().inset(25)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleImageView.snp.bottom).offset(9)
            $0.leading.equalTo(titleImageView.snp.leading)
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
        
        pushSignUpButton.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(divideLineButton.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(140)
        }
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(15)
            $0.leading.equalTo(inputPasswordTextField.snp.leading).offset(5)
        }
    }
}

