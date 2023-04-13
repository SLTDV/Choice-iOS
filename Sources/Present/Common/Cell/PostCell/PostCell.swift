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
    func postVoteButtonDidTap(idx: Int, choice: Int)
}

final class PostCell: UITableViewCell {
    // MARK: - Properties
    
    var model: PostModel?
    var delegate: PostTableViewCellButtonDelegate?
    var postVoteButtonDelegate: PostVoteButtonDidTapDelegate?
    
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
            setHomeVotePostLayout(voting: 1)
            postVoteButtonDelegate?.postVoteButtonDidTap(idx: model!.idx, choice: 1)
            
            startAnimation(button: firstPostVoteButton)
        case 1:
            setHomeVotePostLayout(voting: 2)
            postVoteButtonDelegate?.postVoteButtonDidTap(idx: model!.idx, choice: 2)
            
            startAnimation(button: secondPostVoteButton)
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
        DispatchQueue.main.async { [weak self] in
            switch voting {
            case 1:
                self?.firstPostVoteButton.isEnabled = false
                self?.firstPostVoteButton.backgroundColor = .black
                self?.firstPostVoteButton.setTitleColor(.white, for: .normal)

                self?.secondPostVoteButton.isEnabled = true
                self?.secondPostVoteButton.backgroundColor = .clear
                self?.secondPostVoteButton.setTitleColor(.gray, for: .normal)
            case 2:
                self?.firstPostVoteButton.isEnabled = true
                self?.firstPostVoteButton.backgroundColor = .clear
                self?.firstPostVoteButton.setTitleColor(.gray, for: .normal)
                
                self?.secondPostVoteButton.isEnabled = false
                self?.secondPostVoteButton.backgroundColor = .black
                self?.secondPostVoteButton.setTitleColor(.white, for: .normal)
            default:
                self?.firstPostVoteButton.backgroundColor = .clear
                self?.firstPostVoteButton.setTitleColor(.gray, for: .normal)

                self?.secondPostVoteButton.backgroundColor = .clear
                self?.secondPostVoteButton.setTitleColor(.gray, for: .normal)
            }
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
        
        switch voting {
        case 1:
            firstPostVoteButton.layer.borderColor = UIColor.black.cgColor
            firstPostVoteButton.backgroundColor = .black
            
            secondPostVoteButton.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
            secondPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
        case 2:
            firstPostVoteButton.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
            firstPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            
            secondPostVoteButton.layer.borderColor = UIColor.black.cgColor
            secondPostVoteButton.backgroundColor = .black
        default:
            firstPostVoteButton.layer.borderColor = UIColor.clear.cgColor
            firstPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            
            secondPostVoteButton.layer.borderColor = UIColor.clear.cgColor
            secondPostVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            
            firstPostVoteButton.setTitle("0%(0명)", for: .normal)
            secondPostVoteButton.setTitle("0%(0명)", for: .normal)
        }
    }
    
    func changeCellData(with model: PostModel, type: ViewControllerType) {
        self.model = model
        guard let firstImageUrl = URL(string: model.firstImageUrl) else { return }
        guard let secondImageUrl = URL(string: model.secondImageUrl) else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.contentLabel.text = model.content
            self.firstVoteOptionBackgroundView.setVoteOptionLabel(model.firstVotingOption)
            self.secondVoteOptionBackgroundView.setVoteOptionLabel(model.secondVotingOption)
            self.firstPostImageView.kf.setImage(with: firstImageUrl)
            self.secondPostImageView.kf.setImage(with: secondImageUrl)
            switch type {
            case .home:
                self.setHomeVotePostLayout(voting: model.votingState)
            case .profile:
                self.setProfileVoteButtonLayout(with: model)
            }
            self.participantsCountLabel.text = "👻 참여자 \(model.participants)명"
            self.commentCountLabel.text = "🔥 댓글 \(model.commentCount)개"
        }
    }
}
