import UIKit
import RxSwift
import RxCocoa
import Shared

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
    
    private let inputPhoneNumberTextField = BoxTextField().then {
        $0.placeholder = "전화번호"
        $0.keyboardType = .numberPad
    }
    
    private let inputPasswordTextField = BoxTextField(type: .secureTextField).then {
        $0.placeholder = "비밀번호"
        $0.isSecureTextEntry = true
    }
    
    private let findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호를 잊어버리셨나요?", for: .normal)
        $0.setTitleColor(UIColor.gray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
    
    private let warningLabel = WarningLabel()
    
    private func showSignInError() {
        warningLabel.show(warning: "존재하지 않는 계정입니다.")
        inputPhoneNumberTextField.shake()
        inputPasswordTextField.shake()
    }
    
    private func bind() {
        signInButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                let phoneNumber = owner.inputPhoneNumberTextField.text!
                let password = owner.inputPasswordTextField.text!
                let fcmToken = UserDefaults.standard.string(forKey: "fcmToken")
                
                LoadingIndicator.showLoading(text: "")
                
                owner.viewModel.requestSignIn(model: SignInRequestModel(
                    phoneNumber: phoneNumber,
                    password: password,
                    fcmToken: fcmToken
                )).subscribe(onError: { [weak self] _ in
                    self?.showSignInError()
                    UserDefaults.standard.removeObject(forKey: "fcmToken")
                }).disposed(by: owner.disposeBag)
            }.disposed(by: disposeBag)
        
        
        pushSignUpButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.pushSignUpVC()
            }.disposed(by: disposeBag)
        
        findPasswordButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.viewModel.pushFindPassword()
            }.disposed(by: disposeBag)
    }
    
    override func configureVC() {
        bind()
    }
    
    override func addView() {
        view.addSubviews(
            titleImageView, subTitleLabel,
            inputPhoneNumberTextField, inputPasswordTextField,
            findPasswordButton, signInButton, divideLineButton,
            pushSignUpButton, warningLabel)
    }
    
    override func setLayout() {
        titleImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(112)
            $0.leading.equalToSuperview().inset(25)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleImageView.snp.bottom).offset(9)
            $0.leading.equalTo(titleImageView.snp.leading)
        }
        
        inputPhoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(64)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
        
        inputPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextField.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
        
        findPasswordButton.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(7)
            $0.trailing.equalTo(inputPasswordTextField.snp.trailing)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(42)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
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
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(12)
            $0.leading.equalTo(inputPasswordTextField.snp.leading).offset(5)
        }
    }
}

