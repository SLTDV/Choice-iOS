import UIKit

final class UserInformationViewController: BaseVC<UserInformationViewModel> {
    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
    }
    
    private lazy var editProfileImageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus.circle.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        $0.tintColor = .systemBlue
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }
    
    private let imagePickerController = UIImagePickerController()
    
    private let userNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    override func addView() {
        view.addSubviews(profileImageView, editProfileImageButton, userNameLabel, underLineView, completeButton)
    }
    
    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            $0.size.equalTo(140)
        }
        
        editProfileImageButton.snp.makeConstraints {
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.bottom.equalTo(profileImageView.snp.bottom)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(100)
            $0.height.equalTo(1)
        }
        
        completeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(49)
        }
    }
}
