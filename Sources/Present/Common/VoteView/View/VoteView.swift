import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class VoteView: UIView {
    private let disposeBag = DisposeBag()
    
    private var model: PostModel?
    
    private lazy var firstVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.isEnabled = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.79, green: 0.81, blue: 0.83, alpha: 1)
    }
    
    private lazy var secondVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.isEnabled = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .init(red: 0.79, green: 0.81, blue: 0.83, alpha: 1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//
//        DispatchQueue.main.async {
//            UIView.animate(withDuration: 1.0) {
//                self.firstVoteButton.frame = CGRect(x: 0, y: 0, width: 80, height: 0)
//                self.secondVoteButton.frame = CGRect(x: 0, y: 0, width: -80, height: 0)
//            }
//        }

    func setVoteButtonLayout(with model: PostModel) {
        self.model = model
        
        switch model.voting {
        case 1:
            VotePostLayout(type: .first)
        case 2:
            VotePostLayout(type: .second)
        default:
            return
        }
        
        let data = calculateToVoteCountPercentage(firstVotingCount: Double(model.firstVotingCount),
                                       secondVotingCount: Double(model.secondVotingCount))
        firstVoteButton.setTitle("\(data.0)%(\(data.2)명)", for: .normal)
        secondVoteButton.setTitle("\(data.1)%(\(data.3)명)", for: .normal)
        
    }
    
    private func VotePostLayout(type: ClassifyVoteButtonType) {
        switch type {
        case .first:
            firstVoteButton = firstVoteButton.then {
                $0.layer.borderColor = UIColor.black.cgColor
                $0.isEnabled = false
                $0.backgroundColor = .black
            }
            
            secondVoteButton = secondVoteButton.then {
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.isEnabled = true
                $0.backgroundColor = ChoiceAsset.Colors.grayDark.color
            }
        case .second:
            firstVoteButton = firstVoteButton.then {
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.isEnabled = true
                $0.backgroundColor = ChoiceAsset.Colors.grayDark.color
            }
            
            secondVoteButton = secondVoteButton.then {
                $0.layer.borderColor = UIColor.black.cgColor
                $0.isEnabled = false
                $0.backgroundColor = .black
            }
        }
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

