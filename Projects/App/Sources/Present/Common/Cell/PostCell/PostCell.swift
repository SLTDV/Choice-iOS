import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa
import DesignSystem

// MARK: - Protocol
protocol RemoveTableViewCellHandlerProtocol: AnyObject {
    func removePostButtonDidTap(postIdx: Int)
}

protocol PostVoteButtonHandlerProtocol: AnyObject {
    func postVoteButtonDidTap(idx: Int, choice: Int)
}

protocol ImageLoadingFailureHandlerProtocol: AnyObject {
    func showAlertOnFailedImageLoading()
}

final class PostCell: UITableViewCell {
    // MARK: - Properties
    var hasFailedImageLoading = false
    var model = BehaviorRelay<PostList>(value: PostList(idx: 0,
                                                        firstImageUrl: "",
                                                        secondImageUrl: "",
                                                        title: "",
                                                        content: "",
                                                        firstVotingOption: "",
                                                        secondVotingOption: "",
                                                        firstVotingCount: 0,
                                                        secondVotingCount: 0,
                                                        votingState: 0,
                                                        participants: 0,
                                                        commentCount: 0))
    weak var removeCellDelegate: RemoveTableViewCellHandlerProtocol?
    weak var postVoteButtonDelegate: PostVoteButtonHandlerProtocol?
    weak var failedImageLoadingDelegate: ImageLoadingFailureHandlerProtocol?
    var type: ViewControllerType = .home
    var disposeBag = DisposeBag()
    
    static let identifier = "PostCellIdentifier"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
    }
    
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 5
        $0.font = .systemFont(ofSize: 14)
    }
    
    private lazy var removePostButton = UIButton().then {
        $0.showsMenuAsPrimaryAction = true
        $0.menu = UIMenu(title: "", children: [UIAction(
            title: "게시물 삭제",
            attributes: .destructive,
            handler: { [weak self] _ in
                self?.removePostButtonDidTap(postIdx: (self?.model.value.idx)!)
            })])
        $0.isHidden = true
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    private let firstVoteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let secondVoteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
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
    
    private lazy var firstVoteButton = UIButton().then {
        $0.tag = 1
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = DesignSystemAsset.Colors.grayBackground.color
        $0.addTarget(self, action: #selector(PostVoteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private lazy var secondVoteButton = UIButton().then {
        $0.tag = 2
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = DesignSystemAsset.Colors.grayBackground.color
        $0.addTarget(self, action: #selector(PostVoteButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let participantsCountImageView = UIImageView().then {
        $0.image = ChoiceAsset.Images.voteCountEmoji.image
    }
    
    private let commentCountImageView = UIImageView().then {
        $0.image = ChoiceAsset.Images.commentCountEmoji.image
    }
    
    private let participantsCountLabel = UILabel().then {
        $0.text = "참여자 없음"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private let commentCountLabel = UILabel().then {
        $0.text = "댓글 없음 "
        $0.font = .systemFont(ofSize: 14, weight: .medium)
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
            model.value.firstVotingCount += 1
            model.value.secondVotingCount -= 1
            model.value.secondVotingCount = max(0, model.value.secondVotingCount)
            startAnimation(button: firstVoteButton)
        case 2:
            model.value.firstVotingCount -= 1
            model.value.secondVotingCount += 1
            model.value.firstVotingCount = max(0, model.value.firstVotingCount)
            startAnimation(button: secondVoteButton)
        default:
            return
        }
        
        model.value.votingState = sender.tag
        postVoteButtonDelegate?.postVoteButtonDidTap(idx: model.value.idx, choice: sender.tag)
        DispatchQueue.main.async {
            self.setHomeVotePostLayout(voting: sender.tag)
        }
    }
    
    func removePostButtonDidTap(postIdx: Int) {
        removeCellDelegate?.removePostButtonDidTap(postIdx: postIdx)
    }
    
    private func addView() {
        contentView.addSubviews(
            titleLabel, contentLabel, removePostButton,
            firstVoteOptionLabel, secondVoteOptionLabel,
            firstPostImageView, secondPostImageView,
            firstVoteButton, secondVoteButton,
            participantsCountImageView, commentCountImageView,
            participantsCountLabel, commentCountLabel)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(23)
            $0.leading.trailing.equalToSuperview().inset(33)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(33)
        }
        
        removePostButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(27)
            $0.trailing.equalToSuperview().inset(30)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(15)
            $0.size.equalTo(165)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().inset(15)
            $0.size.equalTo(165)
        }
        
        firstVoteButton.snp.makeConstraints {
            $0.top.equalTo(firstPostImageView.snp.bottom).offset(26)
            $0.centerX.equalTo(firstPostImageView)
            $0.width.equalTo(150)
            $0.height.equalTo(68)
        }
        
        secondVoteButton.snp.makeConstraints {
            $0.top.equalTo(secondPostImageView.snp.bottom).offset(26)
            $0.centerX.equalTo(secondPostImageView)
            $0.width.equalTo(150)
            $0.height.equalTo(68)
        }
        
        participantsCountImageView.snp.makeConstraints {
            $0.top.equalTo(firstVoteButton.snp.bottom).offset(25)
            $0.leading.equalTo(firstVoteButton.snp.leading)
            $0.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
        
        participantsCountLabel.snp.makeConstraints {
            $0.top.equalTo(participantsCountImageView.snp.top).offset(3)
            $0.leading.equalTo(participantsCountImageView.snp.trailing).offset(4)
        }
        
        commentCountImageView.snp.makeConstraints {
            $0.top.equalTo(firstVoteButton.snp.bottom).offset(25)
            $0.leading.equalTo(participantsCountLabel.snp.trailing).offset(13)
            $0.bottom.equalToSuperview().inset(16)
            $0.size.equalTo(20)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.top.equalTo(commentCountImageView.snp.top).offset(3)
            $0.leading.equalTo(commentCountImageView.snp.trailing).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Main
    private func setHomeVotePostLayout(voting: Int) {
        setVoteButtonTitleColors(color: .white)
        
        firstVoteButton.isEnabled = (voting == 1) ? false : true
        firstVoteButton.backgroundColor = (voting == 1) ? .black : DesignSystemAsset.Colors.grayVoteButton.color
        secondVoteButton.isEnabled = (voting == 2) ? false : true
        secondVoteButton.backgroundColor = (voting == 2) ? .black : DesignSystemAsset.Colors.grayVoteButton.color
    }
    
    // MARK: - Profile
    private func setProfileVoteButtonLayout(with model: PostList) {
        let data = CalculateToVoteCountPercentage
            .calculateToVoteCountPercentage(firstVotingCount: Double(model.firstVotingCount),
                                            secondVotingCount: Double(model.secondVotingCount))
        
        DispatchQueue.main.async { [weak self] in
            self?.firstVoteButton.isEnabled = false
            self?.secondVoteButton.isEnabled = false
            self?.removePostButton.isHidden = false
            
            self?.setVoteButtonTitles(firstTitle: "\(data.0)%(\(data.2)명)",
                                      secondTitle: "\(data.1)%(\(data.3)명)")
        }
        
        votePostButtonLayout(voting: model.votingState)
    }
    
    private func setVoteOptionLabelLayout() {
        firstVoteOptionLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(firstPostImageView)
        }
        
        secondVoteOptionLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(30)
            $0.centerX.equalTo(secondPostImageView)
        }
        
        firstPostImageView.snp.remakeConstraints {
            $0.top.equalTo(firstVoteOptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(160)
        }
        
        secondPostImageView.snp.remakeConstraints {
            $0.top.equalTo(secondVoteOptionLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(160)
        }
    }
    
    private func votePostButtonLayout(voting: Int) {
        firstVoteButton.snp.updateConstraints {
            $0.height.equalTo(68)
        }
        
        secondVoteButton.snp.updateConstraints {
            $0.height.equalTo(68)
        }
        
        setVoteButtonTitleColors(color: .white)
        
        switch voting {
        case 1:
            setVoteButtonBackgroundColors(firstSelected: true, secondSelected: false)
        case 2:
            setVoteButtonBackgroundColors(firstSelected: false, secondSelected: true)
        default:
            setVoteButtonBackgroundColors(firstSelected: false, secondSelected: false)
            setVoteButtonTitles(firstTitle: "0%(0명)", secondTitle: "0%(0명)")
        }
    }
    
    private func setVoteButtonBackgroundColors(firstSelected: Bool, secondSelected: Bool) {
        firstVoteButton.backgroundColor = firstSelected ? .black : DesignSystemAsset.Colors.grayDark.color
        secondVoteButton.backgroundColor = secondSelected ? .black : DesignSystemAsset.Colors.grayDark.color
    }
    
    private func setVoteButtonTitles(firstTitle: String, secondTitle: String) {
        firstVoteButton.setTitle(firstTitle, for: .normal)
        secondVoteButton.setTitle(secondTitle, for: .normal)
    }
    
    private func setVoteButtonTitleColors(color: UIColor) {
        firstVoteButton.setTitleColor(color, for: .normal)
        secondVoteButton.setTitleColor(color, for: .normal)
    }
    
    // MARK: - prepare
    
    override func prepareForReuse() {
        super.prepareForReuse()
        firstPostImageView.image = nil
        secondPostImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func configure(with model: PostList) {
        self.model.accept(model)
        
        self.model
            .filter { [weak self] _ in self?.hasFailedImageLoading == false }
            .compactMap {
                guard let firstUrl = URL(string: $0.firstImageUrl),
                      let secondUrl = URL(string: $0.secondImageUrl)
                else {
                    return nil
                }
                return (firstUrl, secondUrl)
            }
            .bind(with: self) { (owner, url: (URL, URL)) in
                let (firstImageUrl, secondImageUrl) = url
                let model = owner.model.value
                owner.titleLabel.text = model.title
                owner.contentLabel.text = model.content
                DispatchQueue.main.async {
                    Downsampling.optimization(imageAt: firstImageUrl,
                                              to: owner.firstPostImageView.frame.size,
                                              scale: 2) { image in
                        if let image = image {
                            owner.firstPostImageView.image = image
                        } else {
                            owner.hasFailedImageLoading = true
                            owner.failedImageLoadingDelegate?.showAlertOnFailedImageLoading()
                        }
                    }
                    
                    Downsampling.optimization(imageAt: secondImageUrl,
                                              to: owner.secondPostImageView.frame.size,
                                              scale: 2) { image in
                        if let image = image {
                            owner.secondPostImageView.image = image
                        } else {
                            owner.hasFailedImageLoading = true
                            owner.failedImageLoadingDelegate?.showAlertOnFailedImageLoading()
                        }
                    }
                }
                
                switch owner.type {
                case .home:
                    owner.setVoteButtonTitles(firstTitle: model.firstVotingOption,
                                        secondTitle: model.secondVotingOption)
                    owner.setHomeVotePostLayout(voting: model.votingState)
                case .profile:
                    owner.firstVoteOptionLabel.text = model.firstVotingOption
                    owner.secondVoteOptionLabel.text = model.secondVotingOption
                    owner.setProfileVoteButtonLayout(with: model)
                    owner.setVoteOptionLabelLayout()
                }
                owner.participantsCountLabel.text = "참여자 \(model.participants)명"
                owner.commentCountLabel.text = "댓글 \(model.commentCount)개"
            }.disposed(by: disposeBag)
    }
    
    func setType(type: ViewControllerType) {
        self.type = type
    }
}
