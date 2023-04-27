import UIKit

final class RegistrationPasswordViewController: BaseVC<RegistrationPasswordViewModel> {
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
