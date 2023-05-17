import UIKit
import RxSwift
import RxCocoa
import Shared

final class RegistrationPasswordViewController: BaseVC<RegistrationPasswordViewModel> {
    private let disposeBag = DisposeBag()
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let inputPasswordTextField = BoxTextField().then {
        $0.placeholder = "8~16자리 영문, 숫자, 특수문자 조합"
        $0.isSecureTextEntry = true
    }
    
    private let checkPasswordTextField = BoxTextField().then {
        $0.placeholder = "비밀번호 재입력"
        $0.isSecureTextEntry = true
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.isEnabled = false
        $0.backgroundColor = SharedAsset.Colors.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = WarningLabel()
    
    private func bindUI() {
        let passwordObservable = inputPasswordTextField.rx.text.orEmpty
        let checkPasswordObservable = checkPasswordTextField.rx.text.orEmpty
        
        Observable.combineLatest(
            passwordObservable,
            checkPasswordObservable,
            resultSelector: { s1, s2 in (8...16).contains(s1.count) && (8...16).contains(s2.count) }
        )
        .bind(with: self) { owner, isValid in
            owner.nextButton.isEnabled = isValid
            owner.nextButton.backgroundColor = isValid ? .black : SharedAsset.Colors.grayVoteButton.color
        }.disposed(by: disposeBag)
    }
    
    private func checkPassword() {
        guard let password = inputPasswordTextField.text else { return }
        guard let checkPassword = checkPasswordTextField.text else { return }
        
        if password.elementsEqual(checkPassword) {
            if self.viewModel.isValidPassword(password: password){
                self.viewModel.pushUserProfileInfoVC(password: password)
            } else {
                self.warningLabel.show(warning: "*비밀번호 형식이 올바르지 않아요.")
            }
        } else {
            self.warningLabel.show(warning: "*비밀번호가 일치하지 않아요.")
        }
        
        LoadingIndicator.hideLoading()
    }
    
    private func nextButtonDidTap() {
        nextButton.rx.tap
            .bind(with: self) { owner, _ in
                LoadingIndicator.showLoading(text: "")
                owner.checkPassword()
            }.disposed(by: disposeBag)
    }
    
    override func configureVC() {
        bindUI()
        nextButtonDidTap()
        
        navigationItem.title = "회원가입"
    }
    
    override func addView() {
        view.addSubviews(passwordLabel, inputPasswordTextField,
                         checkPasswordTextField, warningLabel, nextButton)
    }
    
    override func setLayout() {
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
        
        checkPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(nextButton.snp.leading)
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets.bottom).inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
    }
}
