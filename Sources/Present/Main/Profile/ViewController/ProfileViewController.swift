import UIKit

class ProfileViewController: BaseVC<ProfileViewModel> {
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    override func addView() {
        view.addSubviews(profileImageView, userNameLabel)
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
    }
}
