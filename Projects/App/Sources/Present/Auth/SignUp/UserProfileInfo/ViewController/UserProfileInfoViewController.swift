import UIKit
import RxSwift
import RxCocoa
import DesignSystem

final class UserProfileInfoViewController: BaseVC<UserProfileInfoViewModel> {
    var phoneNumber: String?
    var password: String?

    var isImageChanged = false
    
    private let disposeBag = DisposeBag()
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 70
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
    }
    
    private lazy var setProfileImageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus.circle.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)),
                            for: .normal)
        $0.tintColor = .systemBlue
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(addImageButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let imagePickerController = UIImagePickerController()
    
    private let userNameTextField = BoxTextField().then {
        $0.placeholder = "닉네임 입력"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let warningLabel = WarningLabel()
    
    private lazy var completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.isEnabled = false
        $0.backgroundColor = DesignSystemAsset.Colors.grayVoteButton.color
        $0.layer.cornerRadius = 8
    }
    
    init(viewModel: UserProfileInfoViewModel, phoneNumber: String, password: String) {
        super.init(viewModel: viewModel)
        self.phoneNumber = phoneNumber
        self.password = password
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addImageButtonDidTap(_ sender: UIButton) {
        self.present(imagePickerController, animated: true)
    }
    
    private func checkNicknameValid(_ nickname: String) -> Bool {
        let trimmedNicknameCount = nickname.trimmingCharacters(in: .whitespaces).count
        return trimmedNicknameCount < 2 || trimmedNicknameCount > 10
    }
    
    private func bindUI() {
        userNameTextField.rx.text.orEmpty
            .map(checkNicknameValid(_:))
            .bind(with: self, onNext: { owner, isValid  in
                if isValid {
                    owner.warningLabel.show(warning: "*2자 이상 10자 이하로 입력해 주세요.")
                    
                    owner.completeButton.isEnabled = false
                    owner.completeButton.backgroundColor = DesignSystemAsset.Colors.grayVoteButton.color
                } else {
                    owner.warningLabel.hide()
                    
                    owner.completeButton.isEnabled = true
                    owner.completeButton.backgroundColor = .black
                }
            })
            .disposed(by: disposeBag)
    }
    
    func checkSignUp() {
        let phoneNumber = phoneNumber
        let password = password
        let nickName = userNameTextField.text
        
        let trimmedNickName = nickName!.trimmingCharacters(in: .whitespaces)
    
        let profileImage = isImageChanged ? profileImageView.image : nil
        
        LoadingIndicator.showLoading(text: "")
        
        viewModel.callToSignUp(phoneNumber: phoneNumber!, password: password!, nickname: trimmedNickName, profileImage: profileImage) { isDuplicate in
            LoadingIndicator.hideLoading()
            if isDuplicate {
                self.viewModel.pushCompleteView()
                self.warningLabel.hide()
            } else {
                self.warningLabel.show(warning: "*이미 존재하는 닉네임 입니다.")
            }
        }
    }
    
    private func completeButtonDidTap() {
        completeButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.presentModal()
            }.disposed(by: disposeBag)
    }
    
    private func presentModal() {
        let vc = PrivacyPolicyModalViewController()
        vc.delegate = self
        
        vc.modalPresentationStyle = .pageSheet
        
        if #available(iOS 16.0, *) {
            vc.sheetPresentationController?.detents = [
                .custom { _ in
                    return 300
                }
            ]
        } else {
            vc.sheetPresentationController?.detents = [.medium()]
            vc.sheetPresentationController?.largestUndimmedDetentIdentifier = .large
        }
        
        self.present(vc, animated: true)
    }
    
    override func configureVC() {
        imagePickerController.delegate = self
        
        completeButtonDidTap()
        bindUI()
    }
    
    override func addView() {
        view.addSubviews(profileImageView, setProfileImageButton,
                         userNameTextField, warningLabel, completeButton)
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
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
        
        warningLabel.snp.makeConstraints {
            $0.leading.equalTo(completeButton.snp.leading)
            $0.bottom.equalTo(completeButton.snp.top).offset(-12)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
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
        isImageChanged = true
    }
}

extension UserProfileInfoViewController: PrivacyPolicyViewControllerDelegate {
    func requestSignUp() {
        checkSignUp()
    }
}
