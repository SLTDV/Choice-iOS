import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

protocol PostTableViewCellButtonDelegate: AnyObject {
    func removePostButtonDidTap()
}

final class PostCell: UITableViewCell, PostTableViewCellButtonDelegate{
    let vm = HomeViewModel(coordinator: .init(navigationController: UINavigationController()))
    var model: PostModel?
    var delegate: PostTableViewCellButtonDelegate?
    
    private let disposeBag = DisposeBag()
    
    static let identifier = "PostCellIdentifier"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var removePostButton = UIButton().then {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(title: "", children: [UIAction(title: "게시물 삭제", attributes: .destructive, handler: {_ in self.removePostButtonDidTap() } )])
        $0.isHidden = true
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    private let firstPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.borderWidth = 4
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private let firstVoteOptionBackgroundView = VoteOptionView()
    
    private let secondVoteOptionBackgroundView = VoteOptionView()
    
    private let secondPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderWidth = 4
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private lazy var firstPostVoteButton = UIButton().then {
        $0.tag = 0
        $0.setTitle("✓", for: .normal)
        $0.setTitleColor(ChoiceAsset.Colors.grayDark.color, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
        $0.backgroundColor = ChoiceAsset.Colors.grayBackground.color
        $0.addTarget(self, action: #selector(PostVoteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private lazy var secondPostVoteButton = UIButton().then {
        $0.tag = 1
        $0.setTitle("✓", for: .normal)
        $0.setTitleColor(ChoiceAsset.Colors.grayDark.color, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
        $0.backgroundColor = ChoiceAsset.Colors.grayBackground.color
        $0.addTarget(self, action: #selector(PostVoteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let participantsCountLabel = UILabel().then {
        $0.text = "👻 참여자 "
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private let commentCountLabel = UILabel().then {
        $0.text = "🔥 댓글 "
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 25
        contentView.backgroundColor = ChoiceAsset.Colors.grayBackground.color
        
        addView()
        setLayout()
        
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func PostVoteButtonDidTap(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            vm.callToAddVoteNumberURL(idx: model!.idx, choice: 1)
            firstVotePostLayout()
        case 1:
            vm.callToAddVoteNumberURL(idx: model!.idx, choice: 2)
            secondVotePostLayout()
        default:
            return
        }
    }
    
    func removePostButtonDidTap() {
        delegate?.removePostButtonDidTap()
    }
    
    private func notVotePostLayout() {
        firstPostImageView.layer.borderColor = UIColor.clear.cgColor
        secondPostImageView.layer.borderColor = UIColor.clear.cgColor
        
        firstPostVoteButton.then {
            $0.isEnabled = true
            $0.backgroundColor = .clear
            $0.setTitleColor(.gray, for: .normal)
        }
        
        secondPostVoteButton.then {
            $0.isEnabled = true
            $0.backgroundColor = .clear
            $0.setTitleColor(.gray, for: .normal)
        }
    }
    
    private func firstVotePostLayout() {
        firstPostImageView.layer.borderColor = UIColor.black.cgColor
        secondPostImageView.layer.borderColor = UIColor.clear.cgColor
        
        firstPostVoteButton.then {
            $0.isEnabled = false
            $0.backgroundColor = .black
            $0.setTitleColor(.white, for: .normal)
        }
        
        secondPostVoteButton.then {
            $0.isEnabled = true
            $0.backgroundColor = .clear
            $0.setTitleColor(.gray, for: .normal)
        }
    }
    
    private func secondVotePostLayout() {
        firstPostImageView.layer.borderColor = UIColor.clear.cgColor
        secondPostImageView.layer.borderColor = UIColor.black.cgColor
        
        firstPostVoteButton.then {
            $0.isEnabled = true
            $0.backgroundColor = .clear
            $0.setTitleColor(.gray, for: .normal)
        }
        
        secondPostVoteButton.then {
            $0.isEnabled = false
            $0.backgroundColor = .black
            $0.setTitleColor(.white, for: .normal)
        }
    }
    
    private func addView() {
        contentView.addSubviews(titleLabel, descriptionLabel, removePostButton, firstPostImageView,
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
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(23)
            $0.height.equalTo(17)
        }
        
        removePostButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(31)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(21)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
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
    
    func changeButtonIsHidden(bool: Bool) {
        self.removePostButton.isHidden = bool
    }
    
    func changeCellData(with model: PostModel) {
        guard let firstImageUrl = URL(string: model.firstImageUrl) else { return }
        guard let secondImageUrl = URL(string: model.secondImageUrl) else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.descriptionLabel.text = model.content
            self.firstVoteOptionBackgroundView.setVoteOptionLabel(model.firstVotingOption)
            self.secondVoteOptionBackgroundView.setVoteOptionLabel(model.secondVotingOption)
            self.firstPostImageView.kf.setImage(with: firstImageUrl)
            self.secondPostImageView.kf.setImage(with: secondImageUrl)
            switch model.voting {
            case 0:
                self.notVotePostLayout()
            case 1:
                self.firstVotePostLayout()
            case 2:
                self.secondVotePostLayout()
            default:
                return
            }
            self.participantsCountLabel.text = "👻 참여자 \(model.participants)명"
            self.commentCountLabel.text = "🔥 댓글 \(model.commentCount)개"
        }
    }
}
