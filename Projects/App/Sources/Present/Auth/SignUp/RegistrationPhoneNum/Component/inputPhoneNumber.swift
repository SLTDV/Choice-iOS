import UIKit
import Shared

class inputphoneNumberComponent: UIView {
    private let emailLabel = UILabel().then {
        $0.text = "전화번호"
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let inputPhoneNumberTextfield = BoxTextField().then {
        $0.placeholder = "전화번호 입력"
        $0.keyboardType = .numberPad
    }
    
    private let requestAuthButton = UIButton().then {
        $0.setTitle("인증 요청", for: .normal)
        $0.isEnabled = false
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.backgroundColor = SharedAsset.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let authNumberTextfield = BoxTextField().then {
        $0.placeholder = "인증번호 입력"
        $0.keyboardType = .numberPad
        $0.isHidden = true
    }
    
    private let countLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private let resendLabel = UILabel().then {
        $0.text = "인증번호가 오지 않나요?"
        $0.font = .systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .gray
        $0.isHidden = true
    }
    
    private let resendButton = UIButton().then {
        $0.setTitle("재요청", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        $0.setTitleColor(.black, for: .normal)
        $0.isHidden = true
    }
    
    private lazy var nextButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
        $0.backgroundColor = SharedAsset.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    private let warningLabel = WarningLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        self.addSubviews(emailLabel,inputPhoneNumberTextfield, requestAuthButton,
                         authNumberTextfield, warningLabel, nextButton,
                         resendLabel, resendButton)
        authNumberTextfield.addSubview(countLabel)
    }
    
    func setLayout() {
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(70)
            $0.leading.equalToSuperview().inset(26)
        }
        
        inputPhoneNumberTextfield.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(26)
            $0.trailing.equalTo(requestAuthButton.snp.leading).offset(-10)
            $0.height.equalTo(58)
        }
        
        requestAuthButton.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextfield.snp.top)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalTo(inputPhoneNumberTextfield.snp.width).multipliedBy(0.4)
            $0.height.equalTo(58)
        }
        
        authNumberTextfield.snp.makeConstraints {
            $0.top.equalTo(inputPhoneNumberTextfield.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(25)
        }
        
        resendLabel.snp.makeConstraints {
            $0.centerY.equalTo(resendButton)
            $0.centerX.equalToSuperview().offset(-20)
        }
        
        resendButton.snp.makeConstraints {
            $0.top.equalTo(authNumberTextfield.snp.bottom).offset(15)
            $0.leading.equalTo(resendLabel.snp.trailing).offset(8)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(nextButton.snp.leading)
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.safeAreaInsets.bottom).inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
    }
}
