import UIKit
import SnapKit
import Then
import RxSwift

final class DetailOptionModalViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    let viewModel = DetailOptionModalViewModel()
    
    private let optionListTableView = UITableView().then {
        $0.selectionFollowsFocus = false
        $0.isScrollEnabled = false
        $0.rowHeight = 65
        $0.register(DetailOptionTableViewCell.self,
                    forCellReuseIdentifier: DetailOptionTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        bindTableView()
        addView()
        setLayout()
    }
    
    private func bindTableView() {
        viewModel.optionData
            .bind(to: optionListTableView.rx.items(
                cellIdentifier: DetailOptionTableViewCell.identifier,
                cellType: DetailOptionTableViewCell.self)) { (row, data, cell) in
                    cell.configure(data: [data])
                    cell.selectionStyle = .none
                }.disposed(by: disposeBag)
    }
    
    private func addView() {
        view.addSubview(optionListTableView)
    }
    
    private func setLayout() {
        optionListTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.width.height.equalToSuperview()
        }
    }
}
