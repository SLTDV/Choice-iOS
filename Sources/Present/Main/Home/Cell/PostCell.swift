import UIKit
import SnapKit
import Then
import Kingfisher
import RxSwift
import RxCocoa

final class PostCell: UITableViewCell {
    let vm = HomeViewModel(coordinator: .init(navigationController: UINavigationController()))
    var postIdx = 0
    private let disposeBag = DisposeBag()
    
    static let identifier = "PostCellIdentifier"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14)
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
        $0.addTarget(self, action: #selector(firstPostVoteButtonDidTap(_:)), for: .touchUpInside)
        $0.setTitle("✓", for: .normal)
        $0.setTitleColor(ChoiceAsset.Colors.grayDark.color, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
        $0.backgroundColor = ChoiceAsset.Colors.grayBackground.color
    }
    
    private let secondPostVoteButton = UIButton().then {
        $0.setTitle("✓", for: .normal)
        $0.setTitleColor(ChoiceAsset.Colors.grayDark.color, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
        $0.backgroundColor = ChoiceAsset.Colors.grayBackground.color
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
//        bindUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private func bindUI() {
//        // MARK: - Intput
//        let voteButtonDidTap = PublishRelay<(Int, Int)>()
//
//        let input = HomeViewModel.Input(voteButtonDidTap: voteButtonDidTap.compactMap { $0 })
//
//        firstPostVoteButton.rx.tap
//            .withUnretained(self)
//            .map { owner, _ in (owner.postIdx, 0)}
//            .bind(with: self) { owner, voting in
//                voteButtonDidTap.accept(voting)
//                print(self.postIdx)
//            }.disposed(by: disposeBag)
//
//        // MARK: - Output
//        let output = HomeViewModel(coordinator: .init(navigationController: UINavigationController())).transform(input)
//
//        Observable.combineLatest(output.firstVoteCountData, output.secondVoteCountData)
//            .withUnretained(self)
//            .map { }
//
//
//    }
    
    @objc private func firstPostVoteButtonDidTap(_ sender: UIButton) {
        vm.votePost111(idx: postIdx, choice: 0)
    }
    
    private func addView() {
        contentView.addSubviews(titleLabel, descriptionLabel, firstPostImageView,
                                secondPostImageView, firstPostVoteButton, secondPostVoteButton,
                                participantsCountLabel, commentCountLabel)
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
            $0.leading.equalToSuperview().inset(23)
            $0.height.equalTo(17)
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
    
    func changeCellData(with model: PostModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.descriptionLabel.text = model.content
            self.participantsCountLabel.text = "👻 참여자 \(model.participants)명"
            self.commentCountLabel.text = "🔥 댓글 \(model.commentCount)개"
            if let imageUrl = URL(string: model.firstImageUrl) {
                self.firstPostImageView.kf.setImage(with: imageUrl)
            }
            if let imageUrl = URL(string: model.secondImageUrl) {
                self.secondPostImageView.kf.setImage(with: imageUrl)
            }
        }
    }
}
