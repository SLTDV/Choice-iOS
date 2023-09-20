import UIKit
import DesignSystem

final class DetailPostView: UIView {
    var type: ViewControllerType?
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
    }
    
    private let divideVotePostImageLineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.Colors.grayMedium.color
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.numberOfLines = 0
    }
    
    private let firstPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    private let secondPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    private let firstVoteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let secondVoteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    let firstVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = DesignSystemAsset.Colors.grayDark.color
    }
    
    let secondVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = DesignSystemAsset.Colors.grayDark.color
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
    
    func setContentLabelNumberOfLines(lines: Int) {
        contentLabel.numberOfLines = lines
    }
    
    func updateVoteButtonsState(votingState: Int) {
        firstVoteButton.isEnabled = (votingState != 1)
        secondVoteButton.isEnabled = (votingState != 2)
    }
    
    private func setVoteButtonTitles(firstTitle: String, secondTitle: String) {
        firstVoteButton.setTitle(firstTitle, for: .normal)
        secondVoteButton.setTitle(secondTitle, for: .normal)
    }
    
    private func setVoteButtonBackgroundColors(firstSelected: Bool, secondSelected: Bool) {
        firstVoteButton.backgroundColor = firstSelected ? .black : DesignSystemAsset.Colors.grayDark.color
        secondVoteButton.backgroundColor = secondSelected ? .black : DesignSystemAsset.Colors.grayDark.color
    }
    
    private func setVoteButtonLayout(voting: Int) {
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
    
    func setVoteButton(with model: PostList) {
        let data = CalculateToVoteCountPercentage.calculateToVoteCountPercentage(
            firstVotingCount: Double(model.firstVotingCount),
            secondVotingCount: Double(model.secondVotingCount)
        )
        setVoteButtonTitles(firstTitle: "\(data.0)%(\(data.2)명)",
                            secondTitle: "\(data.1)%(\(data.3)명)")
        setVoteButtonLayout(voting: model.votingState)
    }
    
    func configure(model: PostList) {
        guard let firstImageUrl = URL(string: model.firstImageUrl) else { return }
        guard let secondImageUrl = URL(string: model.secondImageUrl) else { return }
        
        titleLabel.text = model.title
        contentLabel.text = model.content
        firstVoteOptionLabel.text = model.firstVotingOption
        secondVoteOptionLabel.text = model.secondVotingOption
        
        Downsampling.optimization(imageAt: firstImageUrl,
                                  to: firstPostImageView.frame.size,
                                  scale: 2) { [weak self] image in
            self?.firstPostImageView.image = image
        }
        
        Downsampling.optimization(imageAt: secondImageUrl,
                                  to: secondPostImageView.frame.size,
                                  scale: 2) { [weak self] image in
            self?.secondPostImageView.image = image
        }
        setVoteButton(with: model)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(43)
            $0.top.equalToSuperview().offset(35)
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
