import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: BaseVC<ProfileViewModel>, ProfileDataProtocol {
    var profileData = PublishSubject<[ProfileModel]>()
    
    private let disposeBag = DisposeBag()
    
    private let whiteBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = ChoiceAsset.Colors.mainBackgroundColor.color
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let editUserNameButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.tintColor = .black
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let postTableView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
    }
    
    private func bindTableView() {
        profileData.bind(to: postTableView.rx.items(cellIdentifier: PostCell.identifier,
                                                    cellType: PostCell.self)) { (row, data, cell) in
            cell.changeCellData(with: data.postList[0])
        }.disposed(by: disposeBag)
    }
    
    override func configureVC() {
        view.backgroundColor = ChoiceAsset.Colors.mainBackgroundColor.color
    }
    
    override func addView() {
        view.addSubview(whiteBackgroundView)
        whiteBackgroundView.addSubviews(profileImageView, userNameLabel, editUserNameButton, underLineView)
    }
    
    override func setLayout() {
        whiteBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(315)
        }
        
        profileImageView.snp.makeConstraints {
            $0.bottom.equalTo(userNameLabel.snp.top).offset(-36)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(100)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.bottom.equalTo(underLineView.snp.top).offset(-12)
            $0.centerX.equalToSuperview()
        }
        
        editUserNameButton.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.top)
            $0.trailing.equalToSuperview().inset(50)
        }
        
        underLineView.snp.makeConstraints {
            $0.bottom.equalTo(whiteBackgroundView.snp.bottom).inset(43)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(1)
        }
    }
}
