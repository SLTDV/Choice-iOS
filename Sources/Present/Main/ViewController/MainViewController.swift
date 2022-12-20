import UIKit
import RxSwift
import RxCocoa

class MainViewController: BaseVC<MainViewModel> {
    
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
    
    private let postTableView = UITableView()
    
    private let recentSort = UIAction(title: "최신순으로", image: UIImage(systemName: "clock"), handler: { _ in })
    private let popularSort = UIAction(title: "인기순으로", image: UIImage(systemName: "heart"), handler: { _ in })
    
    private let firstVoteView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.99, green: 0.53, blue: 0.53, alpha: 1)
    }
    private let secondVoteView = UIView().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.53, green: 0.71, blue: 0.99, alpha: 1)
    }
    
    override func configureVC() {
        dropdownButton.menu = UIMenu(title: "정렬", children: [recentSort, popularSort])
        dropdownButton.showsMenuAsPrimaryAction = true
        
        navigationItem.title = "choice"
        navigationItem.rightBarButtonItems = [profileButton, addPostButton]
        
        UIView.animate(withDuration: 2.0) {
            self.firstVoteView.frame = CGRect(x: 0, y: 0, width: 40, height: 0)
            self.secondVoteView.frame = CGRect(x: 0, y: 0, width: -40, height: 0)
        }
    }
    
    override func addView() {
        view.addSubviews(dropdownButton, firstVoteView, secondVoteView)
    }
    
    override func setLayout() {
        dropdownButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.trailing.equalToSuperview().inset(14)
            $0.width.equalTo(64)
            $0.height.equalTo(28)
        }
        
        firstVoteView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(30)
            $0.trailing.equalTo(secondVoteView.snp.leading)
            $0.width.equalTo(UIScreen.main.bounds.width / 3 - 30)
            $0.height.equalTo(100)
        }
        
        secondVoteView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.top.equalToSuperview().inset(30)
            $0.leading.equalTo(firstVoteView.snp.trailing)
            $0.width.equalTo(UIScreen.main.bounds.width / 1.5 - 30)
            $0.height.equalTo(100)
        }
    }
}
