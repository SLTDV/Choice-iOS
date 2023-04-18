import UIKit
import SnapKit
import Then
import Kingfisher

// MARK: - Protocol

protocol PostTableViewCellButtonDelegate: AnyObject {
    func removePostButtonDidTap(postIdx: Int)
}

protocol PostVoteButtonDidTapDelegate: AnyObject {
    func postVoteButtonDidTap(idx: Int, choice: Int)
}

final class PostCell: UITableViewCell {
    // MARK: - Properties
    
    var model: PostModel?
    var delegate: PostTableViewCellButtonDelegate?
    var postVoteButtonDelegate: PostVoteButtonDidTapDelegate?
    
    static let identifier = "PostCellIdentifier"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
    }
    
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var removePostButton = UIButton().then {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(title: "", children: [UIAction(title: "게시물 삭제", attributes: .destructive, handler: { _ in self.removePostButtonDidTap(postIdx: self.model!.idx) })])
        $0.isHidden = true
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    private let firstPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private let secondPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private lazy var firstPostVoteButton = UIButton().then {
        $0.tag = 1
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = ChoiceAsset.Colors.grayBackground.color
        $0.addTarget(self, action: #selector(PostVoteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private lazy var secondPostVoteButton = UIButton().then {
        $0.tag = 2
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = ChoiceAsset.Colors.grayBackground.color
        $0.addTarget(self, action: #selector(PostVoteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let participantsCountLabel = UILabel().then {
        $0.text = "👻 참여자 없음"
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private let commentCountLabel = UILabel().then {
        $0.text = "🔥 댓글 없음 "
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addView()
        setLayout()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    @objc private func PostVoteButtonDidTap(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            model?.firstVotingCount += 1
            model?.secondVotingCount -= 1
            model?.secondVotingCount = (model!.secondVotingCount < 0) ? 0 : model!.secondVotingCount
            startAnimation(button: firstPostVoteButton)
        case 2:
            model?.firstVotingCount -= 1
            model?.secondVotingCount += 1
            model?.firstVotingCount = (model!.firstVotingCount < 0) ? 0 : model!.firstVotingCount
            startAnimation(button: secondPostVoteButton)
        default:
            return
        }
        
        if model?.votingState == 0 {
            self.participantsCountLabel.text = "👻 참여자 \(self.model!.participants + 1)명"
        }
        
        model?.votingState = sender.tag
        postVoteButtonDelegate?.postVoteButtonDidTap(idx: model!.idx, choice: sender.tag)
        DispatchQueue.main.async {
            self.setHomeVotePostLayout(voting: sender.tag)
        }
    }
    
    func removePostButtonDidTap(postIdx: Int) {
        delegate?.removePostButtonDidTap(postIdx: postIdx)
    }
    
    private func addView() {
        contentView.addSubviews(titleLabel, contentLabel, removePostButton, firstPostImageView,
                                secondPostImageView, firstPostVoteButton, secondPostVoteButton,
                                 participantsCountLabel, commentCountLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.leading.equalToSuperview().inset(31)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(31)
        }
        
        removePostButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(31)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(31)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(31)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        firstPostVoteButton.snp.makeConstraints {
            $0.top.equalTo(firstPostImageView.snp.bottom).offset(26)
            $0.leading.equalTo(firstPostImageView.snp.leading)
            $0.trailing.equalTo(firstPostImageView.snp.trailing)
            $0.height.equalTo(56)
        }
        
        secondPostVoteButton.snp.makeConstraints {
            $0.top.equalTo(secondPostImageView.snp.bottom).offset(26)
            $0.leading.equalTo(secondPostImageView.snp.leading)
            $0.trailing.equalTo(secondPostImageView.snp.trailing)
            $0.height.equalTo(56)
        }
        
        participantsCountLabel.snp.makeConstraints {
            $0.top.equalTo(firstPostVoteButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(33)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.top.equalTo(firstPostVoteButton.snp.bottom).offset(20)
            $0.leading.equalTo(participantsCountLabel.snp.trailing).offset(13)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func setHomeVotePostLayout(voting: Int) {
        firstPostVoteButton.setTitleColor(.white, for: .normal)
        secondPostVoteButton.setTitleColor(.white, for: .normal)
        switch voting {
        case 1:
            firstPostVoteButton.isEnabled = false
            firstPostVoteButton.backgroundColor = .black
            
            secondPostVoteButton.isEnabled = true
            secondPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
        case 2:
            firstPostVoteButton.isEnabled = true
            firstPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
            
            secondPostVoteButton.isEnabled = false
            secondPostVoteButton.backgroundColor = .black
        default:
            firstPostVoteButton.isEnabled = true
            firstPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
            
            secondPostVoteButton.isEnabled = true
            secondPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayVoteButton.color
        }
    }
    
    func setProfileVoteButtonLayout(with model: PostModel) {
        let data = CalculateToVoteCountPercentage
            .calculateToVoteCountPercentage(firstVotingCount: Double(model.firstVotingCount),
                                            secondVotingCount: Double(model.secondVotingCount))
        
        DispatchQueue.main.async { [weak self] in
            self?.firstPostVoteButton.isEnabled = false
            self?.secondPostVoteButton.isEnabled = false
            self?.removePostButton.isHidden = false

            self?.firstPostVoteButton.setTitle("\(data.0)%(\(data.2)명)", for: .normal)
            self?.secondPostVoteButton.setTitle("\(data.1)%(\(data.3)명)", for: .normal)
        }
        
        votePostButtonLayout(voting: model.votingState)
    }
    
    private func votePostButtonLayout(voting: Int) {
        firstPostVoteButton.snp.updateConstraints {
            $0.height.equalTo(52)
        }
        
        secondPostVoteButton.snp.updateConstraints {
            $0.height.equalTo(52)
        }
        
        firstPostVoteButton.setTitleColor(.white, for: .normal)
        secondPostVoteButton.setTitleColor(.white, for: .normal)
        
        switch voting {
        case 1:
            firstPostVoteButton.backgroundColor = .black
            secondPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
        case 2:
            firstPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            secondPostVoteButton.backgroundColor = .black
        default:
            firstPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            secondPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            firstPostVoteButton.setTitle("0%(0명)", for: .normal)
            secondPostVoteButton.setTitle("0%(0명)", for: .normal)
        }
    }
    
    func changeCellData(with model: PostModel, type: ViewControllerType) {
        self.model = model
        guard let firstImageUrl = URL(string: model.firstImageUrl) else { return }
        guard let secondImageUrl = URL(string: model.secondImageUrl) else { return }
        titleLabel.text = model.title
        contentLabel.text = model.content
        firstPostImageView.kf.setImage(with: firstImageUrl)
        secondPostImageView.kf.setImage(with: secondImageUrl)
        firstPostVoteButton.setTitle(model.firstVotingOption, for: .normal)
        secondPostVoteButton.setTitle(model.secondVotingOption, for: .normal)
        switch type {
        case .home:
            setHomeVotePostLayout(voting: model.votingState)
        case .profile:
            setProfileVoteButtonLayout(with: model)
        }
        participantsCountLabel.text = "👻 참여자 \(model.participants)명"
        commentCountLabel.text = "🔥 댓글 \(model.commentCount)개"
    }
}
