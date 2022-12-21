import UIKit
import RxSwift
import RxCocoa

class MainViewController: BaseVC<MainViewModel> {
    
    var data = PostModel(idx: "123", thumbnail: "", title: "오늘 저녁 메뉴", content: "오늘 저녁 메뉴를 골라주세요!  썸녀랑 첫 데이트 나왔는데  저녁으로 뭘 먹을까요??????", firstVotingOption: "컵라면", secondVotingOption: "스테이크", firstVotingCount: 12, secondVotingCount: 14)
    
    private let addPostButton = UIBarButtonItem().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "plus.app")
    }
    
    private let profileButton = UIBarButtonItem().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
    }
    
    private let dropdownButton = UIButton().then {
        $0.setTitle("정렬 ↓", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        $0.layer.cornerRadius = 5
    }
    
    private let postTableView = UITableView().then {
        $0.register(PostCell.self, forCellReuseIdentifier: "PostCell")
    }
    
    private let recentSort = UIAction(title: "최신순으로", image: UIImage(systemName: "clock"), handler: { _ in })
    private let popularSort = UIAction(title: "인기순으로", image: UIImage(systemName: "heart"), handler: { _ in })
    
    override func configureVC() {
//        view.backgroundColor = .init(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
        
        dropdownButton.menu = UIMenu(title: "정렬", children: [recentSort, popularSort])
        dropdownButton.showsMenuAsPrimaryAction = true
        
        navigationItem.title = "choice"
        navigationItem.rightBarButtonItems = [profileButton, addPostButton]
        
        postTableView.dataSource = self
        postTableView.rowHeight = 500
    }
    
    override func addView() {
        view.addSubviews(dropdownButton, postTableView)
    }
    
    override func setLayout() {
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

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { return UITableViewCell() }
        
        cell.changeCellData(with: [data])
        
        return cell
    }
}
