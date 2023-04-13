import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

// MARK: - Protocol

protocol PostTableViewCellButtonDelegate: AnyObject {
    func removePostButtonDidTap(postIdx: Int)
}

protocol PostVoteButtonDidTapDelegate: AnyObject {
    func postVoteButtonDidTap(idx: Int, choice: Int, row: Int)
}

final class PostCell: UITableViewCell {
    // MARK: - Properties
    
    var model: PostModel?
    var delegate: PostTableViewCellButtonDelegate?
    var postVoteButtonDelegate: PostVoteButtonDidTapDelegate?
    var row = 0
    
    private let disposeBag = DisposeBag()
    
    static let identifier = "PostCellIdentifier"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
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
    
    private let firstVoteOptionBackgroundView = VoteOptionView()
    
    private let secondVoteOptionBackgroundView = VoteOptionView()
    
    private let secondPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private lazy var firstPostVoteButton = UIButton().then {
        $0.tag = 0
        $0.setTitle("✓", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(PostVoteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private lazy var secondPostVoteButton = UIButton().then {
        $0.tag = 1
        $0.setTitle("✓", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
        $0.backgroundColor = .clear
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
        case 0:
            postVoteButtonDelegate?.postVoteButtonDidTap(idx: model!.idx, choice: 1, row: row)
            DispatchQueue.main.async {
                self.setHomeVotePostLayout(voting: 1)
            }
//            startAnimation(button: firstPostVoteButton)
        case 1:
            postVoteButtonDelegate?.postVoteButtonDidTap(idx: model!.idx, choice: 2, row: row)
            DispatchQueue.main.async {
                self.setHomeVotePostLayout(voting: 2)
            }
//            startAnimation(button: secondPostVoteButton)
        default:
            return
        }
    }
    
    func removePostButtonDidTap(postIdx: Int) {
        delegate?.removePostButtonDidTap(postIdx: postIdx)
    }
    
    private func addView() {
        contentView.addSubviews(titleLabel, contentLabel, removePostButton, firstPostImageView,
                                secondPostImageView, firstPostVoteButton, secondPostVoteButton,
                                participantsCountLabel, commentCountLabel)
        firstPostImageView.addSubview(firstVoteOptionBackgroundView)
        secondPostImageView.addSubview(secondVoteOptionBackgroundView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.leading.equalToSuperview().inset(23)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(21)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(23)
        }
        
        removePostButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(31)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(21)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        firstVoteOptionBackgroundView.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        secondVoteOptionBackgroundView.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        firstPostVoteButton.snp.makeConstraints {
            $0.top.equalTo(firstPostImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(38)
            $0.width.equalTo(101)
            $0.height.equalTo(38)
        }
        
        secondPostVoteButton.snp.makeConstraints {
            $0.top.equalTo(secondPostImageView.snp.bottom).offset(16)
            $0.trailing.equalToSuperview().inset(38)
            $0.width.equalTo(101)
            $0.height.equalTo(38)
        }
        
        participantsCountLabel.snp.makeConstraints {
            $0.top.equalTo(firstPostVoteButton.snp.bottom)
            $0.leading.equalToSuperview().inset(33)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.top.equalTo(firstPostVoteButton.snp.bottom)
            $0.leading.equalTo(participantsCountLabel.snp.trailing).offset(13)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func setHomeVotePostLayout(voting: Int) {
        switch voting {
        case 1:
            firstPostVoteButton.isEnabled = false
            firstPostVoteButton.backgroundColor = .black
            firstPostVoteButton.setTitleColor(.white, for: .normal)
            
            secondPostVoteButton.isEnabled = true
            secondPostVoteButton.backgroundColor = .clear
            secondPostVoteButton.setTitleColor(.gray, for: .normal)
        case 2:
            firstPostVoteButton.isEnabled = true
            firstPostVoteButton.backgroundColor = .clear
            firstPostVoteButton.setTitleColor(.gray, for: .normal)
            
            secondPostVoteButton.isEnabled = false
            secondPostVoteButton.backgroundColor = .black
            secondPostVoteButton.setTitleColor(.white, for: .normal)
        default:
            firstPostVoteButton.isEnabled = true
            firstPostVoteButton.setTitleColor(.gray, for: .normal)
            firstPostVoteButton.backgroundColor = .clear
            
            secondPostVoteButton.isEnabled = true
            secondPostVoteButton.setTitleColor(.gray, for: .normal)
            secondPostVoteButton.backgroundColor = .clear
        }
    }
    
    func setProfileVoteButtonLayout(with model: PostModel) {
        let data = CalculateToVoteCountPercentage
            .calculateToVoteCountPercentage(firstVotingCount: Double(model.firstVotingCount),
                                            secondVotingCount: Double(model.secondVotingCount))
        
        DispatchQueue.main.async { [weak self] in
            self?.firstPostVoteButton.isEnabled = false
            self?.secondPostVoteButton.isEnabled = false

            self?.firstPostVoteButton.setTitle("\(data.0)%(\(data.2)명)", for: .normal)
            self?.secondPostVoteButton.setTitle("\(data.1)%(\(data.3)명)", for: .normal)
        }
        
        votePostButtonLayout(voting: model.votingState)
    }
    
    private func votePostButtonLayout(voting: Int) {
        firstPostVoteButton.snp.updateConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(144)
            $0.height.equalTo(52)
        }
        
        secondPostVoteButton.snp.updateConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(144)
            $0.height.equalTo(52)
        }
        
        firstPostVoteButton.setTitleColor(.white, for: .normal)
        secondPostVoteButton.setTitleColor(.white, for: .normal)
        
        switch voting {
        case 1:
            firstPostVoteButton.backgroundColor = .black
            firstPostVoteButton.setTitleColor(.white, for: .normal)
            
            secondPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            secondPostVoteButton.setTitleColor(.white, for: .normal)
        case 2:
            firstPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            firstPostVoteButton.setTitleColor(.white, for: .normal)
            
            secondPostVoteButton.backgroundColor = .black
            secondPostVoteButton.setTitleColor(.white, for: .normal)
        default:
            firstPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            firstPostVoteButton.setTitleColor(.white, for: .normal)
            
            secondPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            secondPostVoteButton.setTitleColor(.white, for: .normal)
            
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
        firstVoteOptionBackgroundView.setVoteOptionLabel(model.firstVotingOption)
        secondVoteOptionBackgroundView.setVoteOptionLabel(model.secondVotingOption)
        firstPostImageView.kf.setImage(with: firstImageUrl)
        secondPostImageView.kf.setImage(with: secondImageUrl)
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
