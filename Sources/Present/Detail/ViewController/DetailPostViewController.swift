import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class DetailPostViewController: BaseVC<DetailPostViewModel>, CommentDataProtocol {
    var writerNameData = PublishSubject<String>()
    var writerImageStringData = PublishSubject<String?>()
    var commentData = BehaviorRelay<[CommentData]>(value: [])
    private var model: PostModel?
    
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let userImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
    }
    
    private let userNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let divideVotePostImageLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
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
    
    private let firstVoteOptionBackgroundView = VoteOptionView()
    
    private let secondVoteOptionBackgroundView = VoteOptionView()
    
    private lazy var firstVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.isEnabled = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = ChoiceAsset.Colors.grayDark.color
    }
    
    private lazy var secondVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.isEnabled = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = ChoiceAsset.Colors.grayDark.color
    }
    
    private let divideCommentLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let whiteBackgroundView = UIView().then {
        $0.autoresizingMask = .flexibleHeight
        $0.backgroundColor = .white
    }
    
    private let enterCommentTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 13, left: 14, bottom: 14, right: 14)
        $0.text = "댓글을 입력해주세요."
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.layer.cornerRadius = 22
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
    }
    
    private let submitCommentButton = UIButton().then {
        $0.setTitle("게시", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private let commentTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 70
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMethod(_:)))
    
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
    
    private func bindTableView() {
        commentData.bind(to: commentTableView.rx.items(cellIdentifier: CommentCell.identifier,
                                                       cellType: CommentCell.self)) { (row, data, cell) in
            cell.changeCommentData(model: data)
        }.disposed(by: disposeBag)
    }
    
    private func bindUI() {
        writerNameData.bind(with: self, onNext: { owner, arg in
            owner.userNameLabel.text = arg
        }).disposed(by: disposeBag)
        
        writerImageStringData.bind(with: self, onNext: { owner, arg in
            guard arg == nil else {
                owner.userImageView.kf.setImage(with: URL(string: arg!))
                return
            }
        }).disposed(by: disposeBag)
    }
    
    private func submitComment() {
        guard let idx = model?.idx else { return }
        guard let content = enterCommentTextView.text else { return }
        
        LoadingIndicator.showLoading(text: "게시 중")
        viewModel.createComment(idx: idx, content: content) {
            DispatchQueue.main.async {
                self.viewModel.callToCommentData(idx: idx)
                self.commentTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
            LoadingIndicator.hideLoading()
        }
    }
    
    private func submitcommentButtonDidTap() {
        submitCommentButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.submitComment()
                owner.viewModel.callToCommentData(idx: owner.model!.idx)
            }).disposed(by: disposeBag)
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
        votePostLayout(voting: model.voting)
        
        let data = CalculateToVoteCountPercentage.calculateToVoteCountPercentage(
            firstVotingCount: Double(model.firstVotingCount),
            secondVotingCount: Double(model.secondVotingCount))
        firstVoteButton.setTitle("\(data.0)%(\(data.2)명)", for: .normal)
        secondVoteButton.setTitle("\(data.1)%(\(data.3)명)", for: .normal)
    }
    
    private func votePostLayout(voting: Int) {
        switch voting {
        case 1:
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
        case 2:
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
        default:
            firstVoteButton.setTitle("0%(0명)", for: .normal)
            secondVoteButton.setTitle("0%(0명)", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.commentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        viewModel.callToCommentData(idx: model!.idx)
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
        commentTableView.delegate = self
        
        bindTableView()
        bindUI()
        submitcommentButtonDidTap()
        changePostData(model: model!)
    }
    
    override func addView() {
        view.addSubviews(scrollView, whiteBackgroundView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(userImageView, userNameLabel,titleLabel,
                                divideVotePostImageLineView, descriptionLabel,
                                firstPostImageView, secondPostImageView,
                                firstVoteButton, secondVoteButton,
                                divideCommentLineView, commentTableView)
        firstPostImageView.addSubview(firstVoteOptionBackgroundView)
        secondPostImageView.addSubview(secondVoteOptionBackgroundView)
        whiteBackgroundView.addSubviews(enterCommentTextView, submitCommentButton)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.centerX.width.top.bottom.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets).inset(24)
            $0.leading.equalToSuperview().inset(40)
            $0.size.equalTo(24)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.leading.equalTo(userImageView.snp.trailing).offset(9)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(43)
            $0.top.equalTo(userImageView.snp.bottom).offset(30)
        }
        
        divideVotePostImageLineView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview().inset(38)
            $0.height.equalTo(1)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(divideVotePostImageLineView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().offset(43)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(64)
            $0.leading.equalToSuperview().inset(37)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(64)
            $0.trailing.equalToSuperview().inset(37)
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
            $0.leading.equalToSuperview().inset(30)
            $0.width.equalTo(144)
            $0.height.equalTo(52)
        }
        
        secondVoteButton.snp.makeConstraints {
            $0.top.equalTo(secondPostImageView.snp.bottom).offset(38)
            $0.trailing.equalToSuperview().inset(30)
            $0.width.equalTo(144)
            $0.height.equalTo(52)
        }
        
        divideCommentLineView.snp.makeConstraints {
            $0.top.equalTo(firstVoteButton.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(38)
            $0.height.equalTo(1)
        }

        commentTableView.snp.makeConstraints {
            $0.top.equalTo(divideCommentLineView).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        whiteBackgroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        enterCommentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(43)
        }
        
        submitCommentButton.snp.makeConstraints {
            $0.centerY.equalTo(enterCommentTextView)
            $0.trailing.equalTo(enterCommentTextView).inset(17)
        }
    }
}

extension DetailPostViewController: UITextViewDelegate {
    private func setTextViewPlaceholder() {
        if enterCommentTextView.text.isEmpty {
            enterCommentTextView.text = "댓글을 입력해주세요."
            enterCommentTextView.textColor = UIColor.lightGray
        } else if enterCommentTextView.text == "댓글을 입력해주세요."{
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
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.width
        let size = CGSize(width: fixedWidth, height: textView.frame.height)
        print("size height = \(size.height)")
        
//        textView.sizeThatFits(size)
//        textView.reloadInputViews()
        whiteBackgroundView.sizeThatFits(size)
    }
}

extension DetailPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var config: UISwipeActionsConfiguration? = nil
        let commentModel = commentData.value[indexPath.row]
        lazy var contextual = UIContextualAction(style: .destructive, title: nil, handler: { [weak self] _, _, _ in
            self?.viewModel.deleteComment(postIdx: self!.model!.idx, commentIdx: commentModel.idx, completion: { result in
                switch result {
                case .success(()):
                    self?.viewModel.callToCommentData(idx: self!.model!.idx)
                    self?.commentTableView.reloadRows(
                    at: [indexPath],
                    with: .automatic
                    )
                case .failure(let error):
                    print("Delete Faield = \(error.localizedDescription)")
                }
            })
        })
        contextual.image = UIImage(systemName: "trash")

        if commentModel.isMine {
            config = UISwipeActionsConfiguration(actions: [contextual])
        }
        return config
    }
}
