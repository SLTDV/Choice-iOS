import UIKit

class ProfileViewController: BaseVC<ProfileViewModel> {
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.backgroundColor = ChoiceAsset.Colors.mainBackgroundColor.color
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let editUserNameButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    override func addView() {
        view.addSubviews(profileImageView, userNameLabel, editUserNameButton, underLineView)
    }
    
    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(58)
            $0.centerX.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(36)
            $0.centerX.equalToSuperview()
        }
        
        editUserNameButton.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.top)
            $0.trailing.equalToSuperview().inset(50)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(editUserNameButton.snp.bottom).offset(7)
            $0.height.equalTo(1)
        }
    }
}
