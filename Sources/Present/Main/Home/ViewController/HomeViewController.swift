import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseVC<HomeViewModel>, PostItemsProtocol, PostVoteButtonDidTapDelegate {
    private let disposeBag = DisposeBag()
    var postItemsData = BehaviorRelay<[PostModel]>(value: [])
    private let leftLogoImageView = UIImageView().then {
        $0.image = ChoiceAsset.Images.homeLogo.image
    }
    
    private lazy var addPostButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(addPostButtonDidTap(_:))).then {
        $0.tintColor = .black
    }
    
    private lazy var profileButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"),
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(profileButtonDidTap(_:))).then {
        $0.tintColor = .black
    }
    
    private let whiteView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let dropdownButton = UIButton().then {
        $0.showsMenuAsPrimaryAction = true
        $0.setTitle("정렬 ↓", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.backgroundColor = .init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        $0.layer.cornerRadius = 5
    }
    
    private let postTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 400
        $0.showsVerticalScrollIndicator = false
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
    }
    
    @objc private func addPostButtonDidTap(_ sender: UIBarButtonItem) {
        viewModel.pushAddPostVC()
    }
    
    @objc private func profileButtonDidTap(_ sender: UIBarButtonItem) {
        viewModel.pushProfileVC()
    }
    
    private func bindTableView() {
        postItemsData.bind(to: postTableView.rx.items(cellIdentifier: PostCell.identifier,
                                                      cellType: PostCell.self)) { (row, data, cell) in
            cell.changeCellData(with: data, type: .home)
            cell.postVoteButtonDelegate = self
            cell.row = row
        }.disposed(by: disposeBag)
        
        postTableView.rx.modelSelected(PostModel.self)
            .bind(with: self, onNext: { owner, post in
                owner.viewModel.pushDetailPostVC(model: post)
            }).disposed(by: disposeBag)
    }

    func postVoteButtonDidTap(idx: Int, choice: Int) {
        viewModel.callToAddVoteNumber(idx: idx, choice: choice)
    }
    
    override func configureVC() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftLogoImageView)
        navigationItem.rightBarButtonItems = [profileButton, addPostButton]
        
        let recentSort = UIAction(title: "최신순으로", image: UIImage(systemName: "clock"),
                                  handler: { [weak self] _ in self?.viewModel.callToFindData(type: .findNewestPostData)})
        let popularSort = UIAction(title: "인기순으로", image: UIImage(systemName: "heart"),
                                   handler: { [weak self] _ in self?.viewModel.callToFindData(type: .findBestPostData)})
        
        dropdownButton.menu = UIMenu(title: "정렬", children: [recentSort, popularSort])
        
        viewModel.delegate = self
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.callToFindData(type: .findNewestPostData)
    }
    
    override func addView() {
        view.addSubviews(whiteView, postTableView)
        whiteView.addSubview(dropdownButton)
    }
    
    override func setLayout() {
        whiteView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets).inset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(dropdownButton.snp.bottom).offset(12)
        }
        
        dropdownButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalToSuperview().inset(14)
            $0.width.equalTo(64)
            $0.height.equalTo(28)
        }
        
        postTableView.snp.makeConstraints {
            $0.top.equalTo(dropdownButton.snp.bottom).offset(28)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
