import UIKit

class ProfileViewController: BaseVC<ProfileViewModel> {
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    override func addView() {
        view.addSubviews(profileImageView)
    }
    
    override func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(58)
            $0.centerX.equalToSuperview()
        }
        
        
    }
}
