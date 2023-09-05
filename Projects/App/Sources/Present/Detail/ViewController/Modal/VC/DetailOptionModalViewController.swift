import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class DetailOptionModalViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    
    let optionList = [
        OptionData(image: UIImage(systemName: "exclamationmark.circle")!,
                   text: "게시물 신고",
                   color: UIColor.systemRed),
        OptionData(image: UIImage(systemName: "person.crop.circle.badge.xmark")!,
                   text: "사용자 차단",
                   color: UIColor.black),
        OptionData(image: ChoiceAsset.Images.instarIcon.image,
                   text: "Instagram에 공유",
                   color: UIColor.black)
    ]

    let optionData = BehaviorRelay<[OptionData]>(value: [])
    
    private let optionListTableView = UITableView().then {
        $0.selectionFollowsFocus = false
        $0.isScrollEnabled = false
        $0.rowHeight = 65
        $0.register(DetailOptionTableViewCell.self,
                    forCellReuseIdentifier: DetailOptionTableViewCell.identifier)
    }
    
    private func bindTableView() {
        optionData
            .bind(to: optionListTableView.rx.items(
                cellIdentifier: DetailOptionTableViewCell.identifier,
                cellType: DetailOptionTableViewCell.self)) { (row, data, cell) in
                    cell.configure(data: data)
                    cell.selectionStyle = .none
                }.disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        optionData.accept(optionList)
        
        bindTableView()
        addView()
        setLayout()
    }
    
    private func addView() {
        view.addSubview(optionListTableView)
    }
    
    private func setLayout() {
        optionListTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}
