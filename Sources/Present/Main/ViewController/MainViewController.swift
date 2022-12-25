import UIKit
import RxSwift
import RxCocoa

final class MainViewController: BaseVC<MainViewModel>, PostItemsPresentable {
    private let disposeBag = DisposeBag()
    
    var postItemsData = PublishSubject<[PostModel]>()
    
    private let addPostButton = UIBarButtonItem().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "plus.app")
    }
    
    private let profileButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
    }
    
    private let whiteView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let dropdownButton = UIButton().then {
        $0.setTitle("정렬 ↓", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.backgroundColor = .init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        $0.layer.cornerRadius = 5
    }
    
    private let postTableView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: PostCell.identifier)
    }
    
    private func bindTableView() {
        postItemsData.bind(to: postTableView.rx.items(cellIdentifier: PostCell.identifier,
                                                      cellType: PostCell.self)) { (row, data, cell) in
            cell.changeCellData(with: [data])
        }.disposed(by: disposeBag)
    }
    
    override func configureVC() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white
        navBarAppearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        view.backgroundColor = ChoiceAsset.Colors.mainBackgroundColor.color
        
        navigationItem.title = "choice"
        navigationItem.rightBarButtonItems = [profileButton, addPostButton]
        
        let recentSort = UIAction(title: "최신순으로", image: UIImage(systemName: "clock"), handler: { _ in })
        let popularSort = UIAction(title: "인기순으로", image: UIImage(systemName: "heart"), handler: { _ in })
        
        dropdownButton.menu = UIMenu(title: "정렬", children: [recentSort, popularSort])
        dropdownButton.showsMenuAsPrimaryAction = true
        
        postTableView.rowHeight = 500
        postTableView.separatorStyle = .none
        postTableView.backgroundColor = ChoiceAsset.Colors.mainBackgroundColor.color
        
        viewModel.delegate = self
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getFindAllData()
    }
    
    override func addView() {
        view.addSubviews(whiteView, postTableView)
        whiteView.addSubview(dropdownButton)
    }
    
    override func setLayout() {
        whiteView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(-5)
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
            $0.leading.trailing.equalToSuperview().inset(9)
            $0.bottom.equalToSuperview()
        }
    }
}
