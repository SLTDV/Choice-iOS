import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class VoteView: UIView {
    private let disposeBag = DisposeBag()
    
    private let viewModel = HomeViewModel(coordinator: .init(navigationController: UINavigationController()))
    
    private var postIdx = 0
    
    private let firstVoteButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.79, green: 0.81, blue: 0.83, alpha: 1)
    }
    
    private let secondVoteButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.79, green: 0.81, blue: 0.83, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        // MARK: - Input
        let voteButtonDidTapRelay = PublishRelay<(Int, Int)>()
        
        let input = HomeViewModel.Input(
            voteButtonDidTap: voteButtonDidTapRelay.compactMap { $0 }
        )
        
        firstVoteButton
        
        firstVoteButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .map { owner, _ in (owner.postIdx, 0) }
            .bind(with: self) { owner, voting in
                voteButtonDidTapRelay.accept(voting)
            }
            .disposed(by: disposeBag)
        
        secondVoteButton.rx.tap
            .asObservable()
            .withUnretained(self)
            .map { owner, _ in (owner.postIdx, 1) }
            .bind(with: self) { owner, voting in
                voteButtonDidTapRelay.accept(voting)
            }
            .disposed(by: disposeBag)
        
        // MARK: - Output
        let output = viewModel.transform(input)
        
        Observable.combineLatest(output.firstVoteCountData, output.secondVoteCountData)
            .withUnretained(self)
            .map { (owner, arg1) in
                let (first, second) = arg1
                return owner.calculateToVoteCountPercentage(
                    firstVotingCount: Double(first),
                    secondVotingCount: Double(second)
                )
            }
            .bind(with: self) { owner, percentage in
                owner.firstVoteButton.setTitle("\(percentage.0)%(\(percentage.2)명)", for: .normal)
                owner.secondVoteButton.setTitle("\(percentage.1)%(\(percentage.3)명)", for: .normal)
            }
            .disposed(by: disposeBag)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0) {
                self.firstVoteButton.frame = CGRect(x: 0, y: 0, width: 80, height: 0)
                self.secondVoteButton.frame = CGRect(x: 0, y: 0, width: -80, height: 0)
            }
        }
    }
    
    func getVotePostIdx(with model: PostModel) {
        postIdx = model.idx
    }
    
    private func calculateToVoteCountPercentage(firstVotingCount: Double, secondVotingCount: Double) -> (String, String, Int, Int) {
        let sum = firstVotingCount + secondVotingCount
        var firstP = firstVotingCount / sum * 100.0
        var secondP = secondVotingCount / sum * 100.0
        
        firstP = firstP.isNaN ? 0.0 : firstP
        secondP = secondP.isNaN ? 0.0 : secondP
        
        let firstStr = String(format: "%0.2f", firstP)
        let secondStr = String(format: "%0.2f", secondP)
        
        return (firstStr, secondStr, Int(firstVotingCount), Int(secondVotingCount))
    }
    
    private func addView() {
        self.addSubviews(firstVoteButton, secondVoteButton)
    }
    
    private func setLayout() {
        firstVoteButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(144)
            $0.height.equalTo(52)
        }
        
        secondVoteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview()
            $0.width.equalTo(144)
            $0.height.equalTo(52)
        }
    }
}

