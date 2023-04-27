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
    
    override func configureVC() {
        bindUI()
        
        inputPasswordTextfield.delegate = self
        checkPasswordTextfield.delegate = self
    }
    
    override func addView() {
        view.addSubviews(passwordLabel, inputPasswordTextfield,
                         checkPasswordTextfield, nextButton)
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
