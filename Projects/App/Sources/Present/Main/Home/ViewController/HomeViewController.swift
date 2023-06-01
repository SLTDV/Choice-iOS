import UIKit
import RxSwift
import RxCocoa
import Shared

final class HomeViewController: BaseVC<HomeViewModel>, PostItemsProtocol, PostVoteButtonDidTapDelegate {
    // MARK: - Properties
    var postData = BehaviorRelay<[PostList]>(value: [])
    private let disposeBag = DisposeBag()
    var isLastPage = false
    
    private var sortType: MenuOptionType = .findNewestPostData
    
    private let leftLogoImageView = UIImageView().then {
        $0.image = ChoiceAsset.Images.homeLogo.image
    }
    
    private lazy var addPostButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"),
                                                     style: .plain,
                                                     target: nil,
                                                     action: nil).then {
        $0.tintColor = .black
    }
    
    private lazy var profileButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle.fill"),
                                                     style: .plain,
                                                     target: nil,
                                                     action: nil).then {
        $0.tintColor = .black
    }
    
    private let whiteView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let dropdownButton = UIButton().then {
        $0.showsMenuAsPrimaryAction = true
        $0.setTitle("최신순 ↓", for: .normal)
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
    
    // MARK: - Function
    private func navigationBarButtonDidTap() {
        profileButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.viewModel.pushProfileVC()
            }.disposed(by: disposeBag)
        
        addPostButton.rx.tap
            .throttle(.seconds(2), latest: false, scheduler: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.viewModel.pushAddPostVC()
            }.disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        postData
            .asDriver()
            .drive(postTableView.rx.items(cellIdentifier: PostCell.identifier,
                                          cellType: PostCell.self)) { (row, data, cell) in
                cell.configure(with: data, type: .home)
                cell.postVoteButtonDelegate = self
                cell.separatorInset = UIEdgeInsets.zero
            }.disposed(by: disposeBag)
        
        postTableView.rx.modelSelected(PostList.self)
            .asDriver()
            .drive(with: self, onNext: { owner, post in
                owner.viewModel.pushDetailPostVC(model: post, type: .home)
            }).disposed(by: disposeBag)
            
        postTableView.rx.contentOffset
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, arg in
                let contentHeight = owner.postTableView.contentSize.height
                let yOffset = owner.postTableView.contentOffset.y
                let frameHeight = owner.postTableView.frame.size.height
                
                if owner.isLastPage {
                    return
                }
                if yOffset > (contentHeight-frameHeight) {
                    owner.postTableView.tableFooterView = owner.createSpinnerFooter()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        owner.postTableView.performBatchUpdates(nil, completion: nil)
                        owner.viewModel.requestPostData(type: owner.sortType) { result in
                            owner.postTableView.tableFooterView = nil
                            switch result {
                            case .success(let size):
                                if size != 10 {
                                    owner.isLastPage = true
                                } else {
                                    owner.postTableView.reloadData()
                                }
                            case .failure(let error):
                                print("pagination Error = \(error.localizedDescription)")
                                break
                            }
                        }
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func postVoteButtonDidTap(idx: Int, choice: Int) {
        viewModel.requestVote(idx: idx, choice: choice)
    }
    
    private func sortTableViewData(type: MenuOptionType) {
        switch type {
        case .findNewestPostData:
            viewModel.newestPostCurrentPage = -1
        case .findBestPostData:
            viewModel.bestPostCurrentPage = -1
        }
        sortType = type
        viewModel.requestPostData(type: type)
        isLastPage = false
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefreshControl(_:)),
                                 for: .valueChanged)
        postTableView.refreshControl = refreshControl
    }
    
    private func configureDropDown() {
        let recentSort = UIAction(title: "최신순으로",
                                  image: UIImage(systemName: "clock")) { [weak self] _ in
            LoadingIndicator.showLoading(text: "")
            self?.sortTableViewData(type: .findNewestPostData)
            DispatchQueue.main.async {
                self?.postTableView.reloadData()
                self?.postData.accept([])
                self?.dropdownButton.setTitle("최신순 ↓", for: .normal)
            }
        }
        let popularSort = UIAction(title: "인기순으로",
                                   image: UIImage(systemName: "heart")) { [weak self] _ in
            LoadingIndicator.showLoading(text: "")
            self?.sortTableViewData(type: .findBestPostData)
            DispatchQueue.main.async {
                self?.postTableView.reloadData()
                self?.postData.accept([])
                self?.dropdownButton.setTitle("인기순 ↓", for: .normal)
            }
        }
        dropdownButton.menu = UIMenu(title: "정렬", children: [recentSort, popularSort])
    }
    
    @objc private func handleRefreshControl(_ sender: UIRefreshControl) {
        self.postData.accept([])
        sortTableViewData(type: .findNewestPostData)
        DispatchQueue.main.async {
            self.postTableView.reloadData()
            self.postTableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Override
    override func configureVC() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftLogoImageView)
        navigationItem.rightBarButtonItems = [profileButton, addPostButton]
        
        configureDropDown()
        
        viewModel.delegate = self
        bindTableView()
        navigationBarButtonDidTap()
        viewModel.requestPostData(type: sortType)
        configureRefreshControl()
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
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.trailing.equalToSuperview().inset(14)
            $0.width.equalTo(64)
            $0.height.equalTo(28)
        }
        
        postTableView.snp.makeConstraints {
            $0.top.equalTo(dropdownButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
