import UIKit
import RxSwift
import RxCocoa

final class DetailPostViewController: BaseVC<DetailPostViewModel>, CommentDataProtocol {
    var commentData = PublishSubject<[CommentData]>()
    var model: PostModel?
    
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 10, weight: .regular)
    }
    
    private let firstPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.borderWidth = 4
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private let secondPostImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.borderWidth = 4
        $0.layer.cornerRadius = 25
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private let firstVoteOptionBackgroundView = VoteOptionView()
    
    private let secondVoteOptionBackgroundView = VoteOptionView()
    
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
    
    private let divideLineView = UIView().then {
        $0.backgroundColor = .init(red: 0.37, green: 0.36, blue: 0.36, alpha: 1)
    }
    
    private let commentCountLabel = UILabel().then {
        $0.text = "댓글"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private let enterCommentTextView = UITextView().then {
        $0.text = "댓글을 입력해주세요"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = .init(red: 0.629, green: 0.629, blue: 0.629, alpha: 1)
    }
    
    private let enterCommentButton = UIButton().then {
        $0.setTitle("게시", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .black
        $0.isHidden = false
    }
    
    private let commentTableView = UITableView().then {
        $0.rowHeight = 160
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }
    
    init(viewModel: DetailPostViewModel, model: PostModel) {
        super.init(viewModel: viewModel)
        self.model = model
        
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapMethod(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMethod(_:)))
    
    private func bindTableView() {
        commentData.bind(to: commentTableView.rx.items(cellIdentifier: CommentCell.identifier,
                                                       cellType: CommentCell.self)) { (row, data, cell) in
            cell.changeCommentData(model: [data])
        }.disposed(by: disposeBag)
    }
    
    private func enterComment() {
        guard let idx = model?.idx else { return }
        guard let content = enterCommentTextView.text else { return }
        
        self.viewModel.createComment(idx: idx, content: content)
    }
    
    private func commentButtonDidTap() {
        enterCommentButton.rx.tap
            .bind(onNext: {
                self.enterComment()
                self.callToCommentData()
            }).disposed(by: disposeBag)
    }
    
    private func callToCommentData() {
        guard let idx = model?.idx else { return }
        
        viewModel.callToCommentData(idx: idx)
    }
    
    private func changePostData(model: PostModel) {
        guard let firstImageUrl = URL(string: model.firstImageUrl) else { return }
        guard let secondImageUrl = URL(string: model.secondImageUrl) else { return }
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.descriptionLabel.text = model.content
            self.firstVoteOptionBackgroundView.setVoteOptionLabel(model.firstVotingOption)
            self.secondVoteOptionBackgroundView.setVoteOptionLabel(model.secondVotingOption)
            self.firstPostImageView.kf.setImage(with: firstImageUrl)
            self.secondPostImageView.kf.setImage(with: secondImageUrl)
            self.setVoteButtonLayout(with: model)
        }
    }
    
    func setVoteButtonLayout(with model: PostModel) {
        switch model.voting {
        case 1:
            votePostLayout(type: .first)
        case 2:
            votePostLayout(type: .second)
        default:
            votePostLayout(type: .none)
        }
        
        let data = CalculateToVoteCountPercentage.calculateToVoteCountPercentage(firstVotingCount: Double(model.firstVotingCount),
                                       secondVotingCount: Double(model.secondVotingCount))
        firstVoteButton.setTitle("\(data.0)%(\(data.2)명)", for: .normal)
        secondVoteButton.setTitle("\(data.1)%(\(data.3)명)", for: .normal)
    }
    
    private func votePostLayout(type: ClassifyVoteButtonType) {
        switch type {
        case .first:
            firstPostImageView.layer.borderColor = UIColor.black.cgColor
            
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
            secondPostImageView.layer.borderColor = UIColor.black.cgColor
            
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
        case .none:
            firstVoteButton.setTitle("0%(0명)", for: .normal)
            secondVoteButton.setTitle("0%(0명)", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.commentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        callToCommentData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.commentTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] as? CGSize {
                    commentTableView.snp.updateConstraints {
                        $0.height.equalTo(newValue.height + 100)
                    }
                }
            }
        }
    }
    
    override func configureVC() {
        enterCommentTextView.delegate = self
        viewModel.delegate = self
        
        bindTableView()
        commentButtonDidTap()
        changePostData(model: model!)
    }
    
    override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, firstPostImageView,
                                secondPostImageView, firstVoteButton, secondVoteButton,
                                divideLineView, commentCountLabel,
                                enterCommentTextView, enterCommentButton, commentTableView)
        firstPostImageView.addSubview(firstVoteOptionBackgroundView)
        secondPostImageView.addSubview(secondVoteOptionBackgroundView)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.centerX.width.top.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaInsets).inset(12)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().offset(20)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(22)
            $0.leading.equalToSuperview().inset(21)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(22)
            $0.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        firstVoteOptionBackgroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        secondVoteOptionBackgroundView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        firstVoteButton.snp.makeConstraints {
            $0.top.equalTo(firstPostImageView.snp.bottom).offset(38)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(144)
            $0.height.equalTo(52)
        }
        
        secondVoteButton.snp.makeConstraints {
            $0.top.equalTo(secondPostImageView.snp.bottom).offset(38)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(144)
            $0.height.equalTo(52)
        }
        
        divideLineView.snp.makeConstraints {
            $0.top.equalTo(firstVoteButton.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.top.equalTo(divideLineView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(30)
        }
        
        enterCommentTextView.snp.makeConstraints {
            $0.top.equalTo(commentCountLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(83)
        }
        
        enterCommentButton.snp.makeConstraints {
            $0.top.equalTo(enterCommentTextView.snp.bottom).offset(10)
            $0.trailing.equalTo(enterCommentTextView.snp.trailing)
            $0.leading.equalTo(enterCommentTextView.snp.leading).inset(250)
            $0.height.equalTo(30)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(enterCommentButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(3)
            $0.height.equalTo(1)
        }
    }
}

extension DetailPostViewController: UITextViewDelegate {
    private func setTextViewPlaceholder() {
        if enterCommentTextView.text.isEmpty {
            enterCommentTextView.text = "댓글을 입력해주세요"
            enterCommentTextView.textColor = UIColor.lightGray
        } else if enterCommentTextView.text == "댓글을 입력해주세요"{
            enterCommentTextView.text = ""
            enterCommentTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setTextViewPlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setTextViewPlaceholder()
        }
    }
}
