import UIKit
import RxSwift
import RxCocoa

final class ProfileViewController: BaseVC<ProfileViewModel>, ProfileDataProtocol {
    var nicknameData = PublishSubject<String>()
    var postListData = PublishSubject<[PostModel]>()
    
    private let disposeBag = DisposeBag()
    
    let optionItem = [
        UIAction(title: "이용약관", handler: { _ in print("이용약관") }),
        UIAction(title: "회원탈퇴", handler: { _ in print("회원탈퇴") }),
        UIAction(title: "로그아웃", handler: { _ in print("로그아웃") })
    ]
    
    private lazy var optionButton = UIBarButtonItem(image: UIImage(systemName: "gearshape")).then {
        $0.menu = UIMenu(title: "설정", children: optionItem)
    }
    
    private let whiteBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
    }
    
    private let userNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var editUserNameButton = UIButton().then {
        $0.addTarget(self, action: #selector(editUserNameButtonDidTap(_:)), for: .touchUpInside)
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.tintColor = .black
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let postTableView = UITableView().then {
        $0.rowHeight = 500
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
    }
    
    private func bindTableView() {
        postListData.bind(to: postTableView.rx.items(cellIdentifier: PostCell.identifier,
                                                     cellType: PostCell.self)) { (row, data, cell) in
            cell.changeCellData(with: data)
        }.disposed(by: disposeBag)
        
        nicknameData.bind(with: self, onNext: { owner, arg in
            owner.userNameLabel.text = arg
        }).disposed(by: disposeBag)
    }
    
    @objc private func editUserNameButtonDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "닉네임 변경",
                                      message: "변경하실 닉네임을 입력해주세요.",
                                      preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "변경", style: .default) { [weak self] data in
            self?.viewModel.callToChangeNickname(nickname: alert.textFields?[0].text ?? "")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
    
    override func configureVC() {
        view.backgroundColor = .white
        viewModel.delegate = self
        bindTableView()
        viewModel.callToProfileData()
    }
    
    override func addView() {
        view.addSubviews(whiteBackgroundView, postTableView)
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
            $0.bottom.equalTo(underLineView.snp.top).offset(-12)
            $0.trailing.equalToSuperview().inset(50)
        }
        
        underLineView.snp.makeConstraints {
            $0.bottom.equalTo(whiteBackgroundView.snp.bottom).inset(43)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(1)
        }
        
        postTableView.snp.makeConstraints {
            $0.top.equalTo(whiteBackgroundView.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview().inset(9)
            $0.bottom.equalToSuperview()
        }
    }
}
