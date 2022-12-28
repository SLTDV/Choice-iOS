import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseVC<SignInViewModel>, SignInErrorProtocol {
    var statusCodeData = PublishSubject<Int>()
    
    private let disposeBag = DisposeBag()
    
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
    
    override func configureVC() {
        viewModel.delegate = self
        
        signInButton.rx.tap
            .bind(onNext: { [weak self] _ in
                guard let email = self?.inputIdTextField.text else { return }
                guard let password = self?.inputPasswordTextField.text else { return }
                
                self?.statusCodeData.bind(onNext: { [weak self] _ in
                    self?.showWarningLabel(warning: "아이디 또는 비밀번호가 잘못되었습니다.")
                    DispatchQueue.main.async {
                        self?.inputIdTextField.shake()
                        self?.inputPasswordTextField.shake()
                    }
                }).disposed(by: self?.disposeBag ?? .init())
                self?.viewModel.callToSignInAPI(email: email, password: password)
            }).disposed(by: disposeBag)
        
        pushSignUpViewButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.viewModel.pushSignUpVC()
            }).disposed(by: disposeBag)
    }
    
    override func addView() {
        view.addSubviews(titleLabel, subTitleLabel, inputIdTextField, inputPasswordTextField,
                         signInButton, divideLineButton, pushSignUpViewButton, warningLabel)
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
        
        warningLabel.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(15)
            $0.leading.equalTo(inputPasswordTextField.snp.leading).offset(5)
        }
    }
}

