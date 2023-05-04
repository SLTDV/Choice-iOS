import UIKit
import RxSwift
import RxCocoa

final class RegistrationPasswordViewController: BaseVC<RegistrationPasswordViewModel> {
    private let disposeBag = DisposeBag()
    
    private let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let inputPasswordTextfield = UITextField().then {
        $0.addLeftPadding()
        $0.placeholder = "8~16자리 영문, 숫자, 특수문자 조합"
        $0.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    private let checkPasswordTextfield = UITextField().then {
        $0.addLeftPadding()
        $0.placeholder = "비밀번호 재입력"
        $0.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
        $0.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = WarningLabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.isHidden = true
        $0.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
    }
    
    private func bindUI() {
        let passwordObservable = inputPasswordTextfield.rx.text.orEmpty
        let checkPasswordObservable = checkPasswordTextfield.rx.text.orEmpty
        
        Observable.combineLatest(
            passwordObservable,
            checkPasswordObservable,
            resultSelector: { s1, s2 in (s1.count >= 8 && s1.count <= 16) && (s2.count >= 8 && s2.count <= 16) }
        )
        .bind(with: self) { owner, isValid in
            owner.nextButton.isEnabled = isValid
            owner.nextButton.backgroundColor = isValid ? .black : ChoiceAsset.Colors.grayVoteButton.color
        }.disposed(by: disposeBag)
    }
    
    private func testPassword(password: String) -> Bool {
        return viewModel.isValidPassword(password: password)
    }
    
    private func checkPassword() {
        guard let password = inputPasswordTextfield.text else { return }
        guard let checkPassword = checkPasswordTextfield.text else { return }
        
        if password.elementsEqual(checkPassword) {
            if self.testPassword(password: password){
                self.viewModel.pushUserProfileInfoVC(password: password)
            } else {
                self.warningLabel.show(warning: "*비밀번호 형식이 올바르지 않아요.")
            }
        } else {
            self.warningLabel.show(warning: "*비밀번호가 일치하지 않아요.")
        }
    }
    
    private func nextButtonDidTap() {
        nextButton.rx.tap
            .bind(onNext: {
                self.checkPassword()
            }).disposed(by: disposeBag)
    }
    
    override func configureVC() {
        bindUI()
        nextButtonDidTap()
        
        navigationItem.title = "회원가입"
        
        inputPasswordTextfield.delegate = self
        checkPasswordTextfield.delegate = self
    }
    
    override func addView() {
        view.addSubviews(passwordLabel, inputPasswordTextfield,
                         checkPasswordTextfield, warningLabel, nextButton)
    }
    
    override func setLayout() {
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(70)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputPasswordTextfield.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(51)
        }
        
        checkPasswordTextfield.snp.makeConstraints {
            $0.top.equalTo(inputPasswordTextfield.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(51)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(nextButton.snp.leading)
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets.bottom).inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(49)
        }
    }
}

extension RegistrationPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = ChoiceAsset.Colors.grayMedium.color.cgColor
    }
}
