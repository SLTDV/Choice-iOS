import UIKit

final class UserProfileInfoViewController: BaseVC<UserProfileInfoViewModel> {
    var email: String?
    var password: String?
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
    }
    
    private lazy var setProfileImageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus.circle.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        $0.tintColor = .systemBlue
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(addImageButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let imagePickerController = UIImagePickerController()
    
    private let userNameTextField = UITextField().then {
        $0.placeholder = "닉네임"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let warningLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.isHidden = true
        $0.textColor = .init(red: 1, green: 0.363, blue: 0.363, alpha: 1)
    }
    
    private lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(signUpButtonDidTap(_ :)), for: .touchUpInside)
    }
    
    @objc private func addImageButtonDidTap(_ sender: UIButton) {
        self.present(imagePickerController, animated: true)
    }
    
    @objc private func signUpButtonDidTap(_ sender: UIButton) {
        guard let email = email else { return  }
        guard let password = password else { return  }
        guard let nickName = userNameTextField.text else { return }
        guard let profileImage = profileImageView.image else { return }
        
        let trimmedNickName = nickName.trimmingCharacters(in: .whitespaces)
        
        viewModel.callToSignUp(email: email, password: password, nickname: trimmedNickName, profileImage: profileImage) { isDuplicate in
            if isDuplicate {
                self.viewModel.navigateRootVC()
            } else {
                self.showWarningLabel(warning: "*이미 존재하는 닉네임 입니다.")
            }
        }
    }
    
    private func showWarningLabel(warning: String) {
        DispatchQueue.main.async {
            self.warningLabel.isHidden = false
            self.warningLabel.text = warning
        }
    }
    
    override func configureVC() {
        imagePickerController.delegate = self
    }
    
    init(viewModel: UserProfileInfoViewModel, email: String, password: String) {
        super.init(viewModel: viewModel)
        self.email = email
        self.password = password
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addView() {
        view.addSubviews(profileImageView, setProfileImageButton, userNameTextField, underLineView, warningLabel, completeButton)
    }
    
    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.size.equalTo(140)
        }
        
        setProfileImageButton.snp.makeConstraints {
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        userNameTextField.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(userNameTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(100)
            $0.height.equalTo(1)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(completeButton.snp.leading)
            $0.bottom.equalTo(completeButton.snp.top).offset(-12)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(49)
        }
    }
}

extension UserProfileInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        self.profileImageView.image = newImage
        
        picker.dismiss(animated: true, completion: nil)
    }
}
