import UIKit
import Shared

final class DetailPostView: UIView {
    var type: ViewControllerType?
    
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
    }
    
    let divideVotePostImageLineView = UIView().then {
        $0.backgroundColor = SharedAsset.grayMedium.color
    }
    
    let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    let firstPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    let secondPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    let firstVoteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    let secondVoteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    let firstVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = SharedAsset.grayDark.color
    }
    
    let secondVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = SharedAsset.grayDark.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        addSubviews(titleLabel, divideVotePostImageLineView, contentLabel,
                    firstPostImageView, secondPostImageView,
                    firstVoteOptionLabel, secondVoteOptionLabel,
                    firstVoteButton, secondVoteButton)
    }
    
    func updateVoteButtonsState(votingState: Int) {
        firstVoteButton.isEnabled = (votingState != 1)
        secondVoteButton.isEnabled = (votingState != 2)
    }
    
    func setVoteButtonTitles(firstTitle: String, secondTitle: String) {
        firstVoteButton.setTitle(firstTitle, for: .normal)
        secondVoteButton.setTitle(secondTitle, for: .normal)
    }
    
    private func setVoteButtonBackgroundColors(firstSelected: Bool, secondSelected: Bool) {
        firstVoteButton.backgroundColor = firstSelected ? .black : SharedAsset.grayDark.color
        secondVoteButton.backgroundColor = secondSelected ? .black : SharedAsset.grayDark.color
    }
    
    func setVoteButtonLayout(voting: Int) {
        switch voting {
        case 1:
            setVoteButtonBackgroundColors(firstSelected: true, secondSelected: false)
        case 2:
            setVoteButtonBackgroundColors(firstSelected: false, secondSelected: true)
        default:
            setVoteButtonBackgroundColors(firstSelected: false, secondSelected: false)
            if type == .home {
                setVoteButtonTitles(firstTitle: "???", secondTitle: "???")
            }
        }
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(43)
            $0.top.equalToSuperview().offset(30)
        }
        
        divideVotePostImageLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(38)
            $0.height.equalTo(1)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(divideVotePostImageLineView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(43)
        }
        
        firstVoteOptionLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(firstPostImageView)
        }
        
        secondVoteOptionLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(secondPostImageView)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(firstVoteOptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(160)
            $0.height.equalTo(160)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(secondVoteOptionLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(160)
            $0.height.equalTo(160)
        }
        
        firstVoteButton.snp.makeConstraints {
            $0.top.equalTo(firstPostImageView.snp.bottom).offset(26)
            $0.centerX.equalTo(firstPostImageView)
            $0.width.equalTo(144)
            $0.height.equalTo(68)
        }
        
        secondVoteButton.snp.makeConstraints {
            $0.top.equalTo(secondPostImageView.snp.bottom).offset(26)
            $0.centerX.equalTo(secondPostImageView)
            $0.width.equalTo(144)
            $0.height.equalTo(68)
        }
    }
}
