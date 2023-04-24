import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class ProfileViewController: BaseVC<ProfileViewModel>, ProfileDataProtocol {
    var nicknameData = PublishSubject<String>()
    var imageData = PublishSubject<String?>()
    var postListData = BehaviorRelay<[Posts]>(value: [])
    
    private let disposeBag = DisposeBag()
    
    lazy var optionItem = [
        UIAction(title: "회원탈퇴", attributes: .destructive, handler: { _ in self.membershipWithdrawalMenuDidTap()}),
        UIAction(title: "로그아웃", attributes: .destructive, handler: { _ in self.logOutMenuDidTap()})
    ]
    
    private lazy var optionButton = UIBarButtonItem(image: UIImage(systemName: "gearshape")).then {
        $0.menu = UIMenu(title: "설정", children: optionItem)
        $0.tintColor = .black
    }
    
    private let whiteBackgroundView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 50
    }
    
    private lazy var editProfileImageButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus.circle.fill",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        $0.tintColor = .systemBlue
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.addTarget(self, action: #selector(editProfileImageButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let imagePickerController = UIImagePickerController()
    
    private let userNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var editUserNameButton = UIButton().then {
        $0.setImage(UIImage(systemName: "pencil"), for: .normal)
        $0.tintColor = .black
        $0.addTarget(self, action: #selector(editUserNameButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let underLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let postTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 400
        $0.backgroundColor = .white
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
    }
    
    private func bindTableView() {
        postListData.bind(to: postTableView.rx.items(cellIdentifier: PostCell.identifier,
                                                     cellType: PostCell.self)) { (row, data, cell) in
            cell.changeCellData(with: data, type: .profile)
            cell.delegate = self
            cell.separatorInset = UIEdgeInsets.zero
        }.disposed(by: disposeBag)
        
        nicknameData.bind(with: self, onNext: { owner, arg in
            owner.userNameLabel.text = arg
        }).disposed(by: disposeBag)
        
        imageData.bind(with: self, onNext: { owner, arg in
            guard arg == nil else {
                owner.profileImageView.kf.setImage(with: URL(string: arg!))
                return
            }
        }).disposed(by: disposeBag)
    }
    
    @objc private func editProfileImageButtonDidTap(_ sender: UIButton) {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @objc private func editUserNameButtonDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "닉네임 변경",
                                      message: "변경하실 닉네임을 입력해주세요.",
                                      preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "변경", style: .default) { [weak self] data in
            LoadingIndicator.showLoading(text: "")
            self?.viewModel.callToChangeNickname(nickname: alert.textFields?[0].text ?? "")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
    
    private func membershipWithdrawalMenuDidTap() {
        let alert = UIAlertController(title: "회원탈퇴", message: "회원탈퇴 하시겠습니까?", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "탈퇴", style: .destructive) { [weak self] data in
            self?.viewModel.callToDeleteData(type: .callToMembershipWithdrawal)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        
        present(alert, animated: true)
    }
    
    private func logOutMenuDidTap() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] data in
            self?.viewModel.callToDeleteData(type: .callToLogout)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        
        present(alert, animated: true)
    }
    
    override func configureVC() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = optionButton
        
        viewModel.delegate = self
        imagePickerController.delegate = self
        
        bindTableView()
        viewModel.callToProfileData()
    }
    
    override func addView() {
        view.addSubviews(whiteBackgroundView, postTableView)
        whiteBackgroundView.addSubviews(profileImageView, userNameLabel, editUserNameButton,
                                        underLineView, editProfileImageButton, editProfileImageButton)
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
        
        editProfileImageButton.snp.makeConstraints {
            $0.trailing.equalTo(profileImageView.snp.trailing)
            $0.bottom.equalTo(profileImageView.snp.bottom)
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
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage = UIImage()
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        LoadingIndicator.showLoading(text: "")
        viewModel.callToProfileImageUpload(profileImage: newImage)
            .subscribe(with: self, onNext: { owner, response in
                DispatchQueue.main.async {
                    owner.profileImageView.kf.setImage(with: URL(string: response.profileImageUrl))
                    picker.dismiss(animated: true)
                }
            }).disposed(by: disposeBag)
    }
}

extension ProfileViewController: PostTableViewCellButtonDelegate {
    func removePostButtonDidTap(postIdx: Int) {
        let alert = UIAlertController(title: "게시물 삭제", message: "삭제 하시겠습니까?", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.viewModel.callToDeletePost(postIdx: postIdx)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .default)
        
        alert.addAction(cancelAction)
        alert.addAction(okayAction)
        
        self.present(alert, animated: true)
    }
}
