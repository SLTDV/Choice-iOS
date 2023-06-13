import UIKit
import RxSwift
import RxCocoa
import Shared

enum ContentSizeKey {
    static let key = "contentSize"
}

final class DetailPostViewController: BaseVC<DetailPostViewModel>, CommentDataProtocol {
    var writerNameData = PublishSubject<String>()
    var writerImageStringData = PublishSubject<String?>()
    var commentData = BehaviorRelay<[CommentList]>(value: [])
    private var model = BehaviorRelay<PostList>(value: PostList(idx: 0,
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
    var isLastPage = false
    var type: ViewControllerType?
    
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
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 21, weight: .semibold)
    }
    
    private let divideVotePostImageLineView = UIView().then {
        $0.backgroundColor = SharedAsset.grayMedium.color
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
    
    private let firstVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = SharedAsset.grayDark.color
    }
    
    private let secondVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = SharedAsset.grayDark.color
    }
    
    private let divideCommentLineView = UIView().then {
        $0.backgroundColor = SharedAsset.grayMedium.color
    }
    
    private let whiteBackgroundView = UIView().then {
        $0.autoresizingMask = .flexibleHeight
        $0.backgroundColor = .white
    }
    
    private let enterCommentTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 13, left: 14, bottom: 14, right: 50)
        $0.text = "댓글을 입력해주세요."
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.layer.cornerRadius = 22
        $0.layer.borderWidth = 1
        $0.layer.borderColor = SharedAsset.grayDark.color.cgColor
    }
    
    private let submitCommentButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitle("게시", for: .normal)
        $0.setTitleColor(SharedAsset.grayDark.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private let commentTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 70
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = """
        아직 댓글이 없습니다
        댓글을 작성해 보세요!
        """
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textAlignment = .center
        $0.textColor = SharedAsset.grayDark.color
        $0.numberOfLines = 0
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMethod(_:)))
    
    init(viewModel: DetailPostViewModel, model: PostList, type: ViewControllerType) {
        super.init(viewModel: viewModel)
        self.model.accept(model)
        self.type = type
        
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapMethod(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func setKeyboard() {
        let keyboardWillShow = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillHide =
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        
        keyboardWillShow
            .asDriver(onErrorRecover: { _ in .never()})
            .drive(with: self) { owner, noti in
                owner.keyboardUp(noti)
            }.disposed(by: disposeBag)
        
        keyboardWillHide
            .asDriver(onErrorRecover: { _ in .never()})
            .drive(with: self) { owner, noti in
                owner.keyboardDown()
            }.disposed(by: disposeBag)
    }
    
    private func keyboardUp(_ notification: Notification) {
        if let keyboardFrame:CGRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin.y -= keyboardFrame.size.height
                }
            )
        }
    }
    
    private func keyboardDown() {
        self.view.frame.origin.y = .zero
    }
    
    private func bindTableView() {
        commentData.bind(to: commentTableView.rx.items(
            cellIdentifier: CommentCell.identifier,
            cellType: CommentCell.self)) { (row, data, cell) in
            cell.configure(model: data)
        }.disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, _ in
                if owner.isLastPage {
                    owner.updateEmptyLabelLayout()
                    return
                }
                
                let contentHeight = owner.scrollView.contentSize.height
                let yOffset = owner.scrollView.contentOffset.y
                let frameHeight = owner.scrollView.frame.size.height
                let shouldLoadMore = yOffset > (contentHeight-frameHeight) - 100
                
                if shouldLoadMore {
                    owner.loadMoreComments()
                }
            })
            .disposed(by: disposeBag)
    }

    private func updateEmptyLabelLayout() {
        let comments = commentData.value
        if comments.isEmpty && isLastPage {
            emptyLabel.frame = CGRect(x: 0, y: 15, width: commentTableView.bounds.width, height: 100)
            commentTableView.tableHeaderView = emptyLabel
            commentTableView.separatorStyle = .none
        } else {
            commentTableView.tableHeaderView = nil
            commentTableView.separatorStyle = .singleLine
        }
    }
    
    private func loadMoreComments() {
        commentTableView.tableFooterView = createSpinnerFooter()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) { [weak self] in
            guard let self = self else { return }
            
            self.commentTableView.performBatchUpdates(nil, completion: nil)
            self.viewModel.requestCommentData(idx: self.model.value.idx) { [weak self] result in
                guard let self = self else { return }
                
                self.commentTableView.tableFooterView = nil
                
                switch result {
                case .success(let size):
                    if size != 10 {
                        self.isLastPage = true
                    } else {
                        self.commentTableView.reloadData()
                    }
                case .failure(let error):
                    print("comment pagination error = \(error.localizedDescription)")
                }
            }
        }
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
        
        enterCommentTextView.rx.didBeginEditing
            .bind(with: self, onNext: { owner, _ in
                if owner.enterCommentTextView.text == "댓글을 입력해주세요." {
                    owner.enterCommentTextView.text = ""
                    owner.enterCommentTextView.textColor = UIColor.black
                }
            }).disposed(by: disposeBag)
        
        enterCommentTextView.rx.didEndEditing
            .bind(with: self, onNext: { owner, _ in
                if owner.enterCommentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                    owner.setEnterTextViewAutoSize()
                    owner.enterCommentTextView.text = "댓글을 입력해주세요."
                    owner.enterCommentTextView.textColor = UIColor.lightGray
                    owner.setDefaultSubmitButton()
                }
            }).disposed(by: disposeBag)
        
        enterCommentTextView.rx.didChange
            .bind(with: self, onNext: { owner, _ in
                owner.setEnterTextViewAutoSize()

                if owner.enterCommentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count >= 1 {
                    owner.submitCommentButton.isEnabled = true
                    owner.submitCommentButton.setTitleColor(.blue, for: .normal)
                } else {
                    owner.setDefaultSubmitButton()
                }
            }).disposed(by: disposeBag)
        
        firstVoteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.updateVotingStateWithLayout(1)
            }.disposed(by: disposeBag)
        
        secondVoteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.updateVotingStateWithLayout(2)
            }.disposed(by: disposeBag)
    }
    
    private func configure(model: PostList) {
        guard let firstImageUrl = URL(string: model.firstImageUrl) else { return }
        guard let secondImageUrl = URL(string: model.secondImageUrl) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.titleLabel.text = model.title
            self?.contentLabel.text = model.content
            self?.firstVoteOptionLabel.text = model.firstVotingOption
            self?.secondVoteOptionLabel.text = model.secondVotingOption
            self?.firstPostImageView.kf.setImage(with: firstImageUrl)
            self?.secondPostImageView.kf.setImage(with: secondImageUrl)
            self?.setVoteButtonLayout(with: model)
        }
    }
    
    private func updateVotingStateWithLayout(_ votingState: Int) {
        let model = model.value
        
        if model.votingState == votingState {
            return
        }
        
        switch votingState {
        case 1:
            model.firstVotingCount += 1
            model.secondVotingCount -= 1
        case 2:
            model.firstVotingCount -= 1
            model.secondVotingCount += 1
        default:
            break
        }
        
        firstVoteButton.isEnabled = (votingState == 1) ? false : true
        secondVoteButton.isEnabled = (votingState == 2) ? false : true
        
        model.firstVotingCount = max(0, model.firstVotingCount)
        model.secondVotingCount = max(0, model.secondVotingCount)
        
        model.votingState = votingState
        viewModel.requestVote(idx: model.idx, choice: model.votingState)
        setVoteButtonLayout(with: model)
    }
    
    private func setVoteButtonLayout(with model: PostList) {
        let data = CalculateToVoteCountPercentage.calculateToVoteCountPercentage(
            firstVotingCount: Double(model.firstVotingCount),
            secondVotingCount: Double(model.secondVotingCount)
        )
        firstVoteButton.setTitle("\(data.0)%(\(data.2)명)", for: .normal)
        secondVoteButton.setTitle("\(data.1)%(\(data.3)명)", for: .normal)
        setVoteButtonLayout(voting: model.votingState)
    }
    
    private func setVoteButtonLayout(voting: Int) {
        switch voting {
        case 1:
            firstVoteButton.backgroundColor = .black
            secondVoteButton.backgroundColor = SharedAsset.grayDark.color
        case 2:
            firstVoteButton.backgroundColor = SharedAsset.grayDark.color
            secondVoteButton.backgroundColor = .black
        default:
            firstVoteButton.backgroundColor = SharedAsset.grayDark.color
            secondVoteButton.backgroundColor = SharedAsset.grayDark.color
            if type == .home {
                firstVoteButton.setTitle("???", for: .normal)
                secondVoteButton.setTitle("???", for: .normal)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.commentTableView.addObserver(self, forKeyPath: ContentSizeKey.key, options: .new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.commentTableView.removeObserver(self, forKeyPath: ContentSizeKey.key)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == ContentSizeKey.key {
            if object is UITableView {
                if let newValue = change?[.newKey] as? CGSize {
                    commentTableView.snp.updateConstraints {
                        $0.height.equalTo(newValue.height + 50)
                    }
                }
            }
        }
    }
    
    override func configureVC() {
        viewModel.delegate = self
        commentTableView.delegate = self
        
        bindTableView()
        bindUI()
        setKeyboard()
        submitCommentButtonDidTap()
        configure(model: model.value)
    }
    
    override func addView() {
        view.addSubviews(scrollView, whiteBackgroundView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(userImageView, userNameLabel,titleLabel,
                                divideVotePostImageLineView, contentLabel,
                                firstVoteOptionLabel, secondVoteOptionLabel,
                                firstPostImageView, secondPostImageView,
                                firstVoteButton, secondVoteButton,
                                divideCommentLineView, commentTableView)
        whiteBackgroundView.addSubviews(enterCommentTextView, submitCommentButton)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets).inset(24)
            $0.leading.equalToSuperview().inset(40)
            $0.size.equalTo(28)
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
        
        divideCommentLineView.snp.makeConstraints {
            $0.top.equalTo(firstVoteButton.snp.bottom).offset(48)
            $0.leading.trailing.equalToSuperview().inset(38)
            $0.height.equalTo(1)
        }
        
        commentTableView.snp.makeConstraints {
            $0.top.equalTo(divideCommentLineView).offset(32)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        whiteBackgroundView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        enterCommentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.height.equalTo(47)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(33)
        }
        
        submitCommentButton.snp.makeConstraints {
            $0.centerY.equalTo(enterCommentTextView)
            $0.trailing.equalTo(enterCommentTextView).inset(17)
        }
    }
}

extension DetailPostViewController {
    private func setDefaultSubmitButton() {
        submitCommentButton.isEnabled = false
        submitCommentButton.setTitleColor(SharedAsset.grayDark.color, for: .normal)
    }
    
    private func setEnterTextViewAutoSize() {
        let maxHeight = 94.0
        let fixedWidth = enterCommentTextView.frame.size.width
        let size = enterCommentTextView.sizeThatFits(CGSize(width: fixedWidth, height: .infinity))

        enterCommentTextView.isScrollEnabled = size.height > maxHeight
        enterCommentTextView.snp.updateConstraints {
            $0.height.equalTo(min(maxHeight, size.height))
        }
    }
    
    private func submitComment() {
        guard let content = enterCommentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        viewModel.commentCurrentPage = -1
        viewModel.requestToCreateComment(idx: model.value.idx, content: content) { result in
            switch result {
            case .success(()):
                DispatchQueue.main.async { [weak self] in
                    self?.viewModel.requestCommentData(idx: (self?.model.value.idx)!)
                    self?.commentTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    self?.enterCommentTextView.text = nil
                    self?.enterCommentTextView.resignFirstResponder()
                    self?.commentData.accept([])
                    self?.isLastPage = false
                    self?.setDefaultSubmitButton()
                }
            case .failure(let error):
                print("post error = \(String(describing: error.localizedDescription))")
            }
            LoadingIndicator.hideLoading()
        }
    }
    
    private func submitCommentButtonDidTap() {
        submitCommentButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                LoadingIndicator.showLoading(text: "게시 중")
                owner.commentTableView.tableHeaderView = nil
                owner.submitComment()
            }).disposed(by: disposeBag)
    }
}

extension DetailPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var config: UISwipeActionsConfiguration? = nil
        let commentModel = commentData.value[indexPath.row]
        
        lazy var deleteContextual = UIContextualAction(style: .destructive, title: nil, handler: { _, _, _ in
            self.viewModel.requestToDeleteComment(postIdx: self.model.value.idx,
                                                  commentIdx: commentModel.idx) { [weak self] result in
                switch result {
                case .success(()):
                    LoadingIndicator.showLoading(text: "")
                    var arr = self?.commentData.value
                    arr?.remove(at: indexPath.row)
                    self?.commentData.accept(arr!)
                    DispatchQueue.main.async {
                        self?.commentTableView.reloadRows(
                            at: [indexPath],
                            with: .automatic
                        )
                    }
                    LoadingIndicator.hideLoading()
                case .failure(let error):
                    print("Delete Faield = \(error.localizedDescription)")
                }
            }
        })
        deleteContextual.image = UIImage(systemName: "trash")
        
        if commentModel.isMine {
            config = UISwipeActionsConfiguration(actions: [deleteContextual])
        }
        return config
    }
}
