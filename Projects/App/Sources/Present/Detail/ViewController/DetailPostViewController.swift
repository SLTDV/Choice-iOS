import UIKit
import RxSwift
import RxCocoa
import Kingfisher
import DesignSystem

enum CommentPlaceHolder {
    static var text = "댓글을 입력해주세요."
}

enum ContentSizeKey {
    static let key = "contentSize"
}

final class DetailPostViewController: BaseVC<DetailPostViewModel>, CommentDataProtocol {
    var detailPostModelRelay = BehaviorRelay<CommentModel>(value: CommentModel())
    private var postListModelRelay = BehaviorRelay<PostList>(value: PostList())
                                                             
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
    
    private lazy var userOptionButton = UIButton().then {
        $0.menu = UIMenu(
            children: [UIAction(
                title: "게시물 신고",
                image: UIImage(systemName: "exclamationmark.circle"),
                attributes: .destructive,
                handler: { [weak self] _ in self?.presentReportPostAlert() }
            ), UIAction(
                title: "차단하기",
                image: UIImage(systemName: "person.crop.circle.badge.xmark"),
                handler: { [weak self] _ in self?.presentBlockUserAlert()}
            )]
        )
        $0.showsMenuAsPrimaryAction = true
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
    }
    
    private let sharePostButton = UIButton().then {
        $0.tintColor = .black
        $0.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
    }
    
    private let detailPostView = DetailPostView()
    
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
        $0.backgroundColor = DesignSystemAsset.Colors.grayDark.color
    }
    
    private let secondVoteButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = DesignSystemAsset.Colors.grayDark.color
    }
    
    private let divideCommentLineView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.Colors.grayMedium.color
    }
    
    private let whiteBackgroundView = UIView().then {
        $0.autoresizingMask = .flexibleHeight
        $0.backgroundColor = .white
    }
    
    private let enterCommentTextView = UITextView().then {
        $0.textContainerInset = UIEdgeInsets(top: 13, left: 14, bottom: 14, right: 50)
        $0.text = CommentPlaceHolder.text
        $0.isScrollEnabled = false
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.layer.cornerRadius = 22
        $0.layer.borderWidth = 1
        $0.layer.borderColor = DesignSystemAsset.Colors.grayDark.color.cgColor
    }
    
    private let submitCommentButton = UIButton().then {
        $0.isEnabled = false
        $0.setTitle("게시", for: .normal)
        $0.setTitleColor(DesignSystemAsset.Colors.grayDark.color, for: .normal)
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
        $0.textColor = DesignSystemAsset.Colors.grayDark.color
        $0.numberOfLines = 0
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(
        target: self,
        action: #selector(tapMethod(_:))
    )
    
    init(viewModel: DetailPostViewModel, model: PostList, type: ViewControllerType) {
        super.init(viewModel: viewModel)
        self.postListModelRelay.accept(model)
        self.type = type
        
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapMethod(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func sharePostButtonDidTap() {
        let backgroundImage = DesignSystemAsset.Images.instaBackground.image
        
        sharePostButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.detailPostView.setContentLabelNumberOfLines(lines: 4)
                DispatchQueue.main.async {
                    ShareToInstagram.shareToInstaStories(detailPostView: owner.detailPostView, backgroundImage: backgroundImage) {
                        owner.presentFailedShareAlert()
                    }
                    owner.detailPostView.setContentLabelNumberOfLines(lines: 0)
                }
            }.disposed(by: disposeBag)
    }
    
    private func presentReportPostAlert() {
        AlertHelper.shared.presentAlert(
            title: "게시물 신고",
            message: """
                    해당 게시물이 불쾌감을 줬다면 신고해주세요.
                    신고가 누적되면 필터링을 통해 게시물이
                    삭제될 수 있습니다. (중복 불가능)
                    """,
            acceptTitle: "신고",
            acceptAction: {
                self.reportPostAlert()
            },
            cancelTitle: "취소",
            vc: self)
    }
    
    private func presentBlockUserAlert() {
        AlertHelper.shared.presentAlert(
            title: "차단하기",
            message: """
                     해당 사용자를 차단할 수 있습니다.
                     차단하면 해당 사용자의 게시물은
                     보이지 않습니다.
                     """,
            acceptTitle: "차단",
            acceptAction: {
                self.blockUserAlert()
            },
            cancelTitle: "취소",
            vc: self)
    }
    
    private func presentFailedShareAlert() {
        AlertHelper.shared.presentAlert(
            title: "실패",
            message: """
                     Instagram이 설치되어 있지 않습니다.
                     """,
            cancelTitle: "확인",
            vc: self)
    }
    
    func setKeyboard() {
        let notiCenter = NotificationCenter.default.rx
        let keyboardWillShow = notiCenter.notification(UIResponder.keyboardWillShowNotification)
        let keyboardWillHide = notiCenter.notification(UIResponder.keyboardWillHideNotification)
        
        keyboardWillShow
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, noti in
                owner.keyboardUp(noti)
            }.disposed(by: disposeBag)
        
        keyboardWillHide
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, _ in
                owner.keyboardDown()
            }.disposed(by: disposeBag)
    }
    
    private func reportPostAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        viewModel.requestToReportPost(postIdx: self.postListModelRelay.value.idx)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                alert.title = "완료"
                alert.message = "신고가 접수되었습니다"
            },onError: {_ in
                alert.title = "실패"
                alert.message = "이미 신고한 게시물입니다"
            }, onDisposed: {
                self.present(alert, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func blockUserAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        viewModel.requestToBlockUser(postIdx: self.postListModelRelay.value.idx)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                alert.title = "완료"
                alert.message = "차단이 완료되었습니다."
                self.viewModel.popToRootVC()
                NotificationCenter.default.post(name: NSNotification.Name("BlockButtonPressed"), object: nil)
            }, onError: { _ in
                alert.title = "실패"
                alert.message = "차단이 완료되었습니다."
            }, onDisposed: {
                self.present(alert, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func keyboardUp(_ notification: Notification) {
        if let keyboardFrame: CGRect = notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? CGRect {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin.y -= keyboardFrame.size.height
            })
        }
    }
    
    private func keyboardDown() {
        self.view.frame.origin.y = .zero
    }
    
    private func bindTableView() {
        detailPostModelRelay
            .map { $0.commentList}
            .bind(to: commentTableView.rx.items(
                cellIdentifier: CommentCell.identifier,
                cellType: CommentCell.self)) { (_, data, cell) in
                    cell.configure(model: data)
                }.disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self) { owner, contentOffset in
                if owner.isLastPage {
                    owner.updateEmptyLabelLayout()
                    return
                }
                
                let contentHeight = owner.scrollView.contentSize.height
                let yOffset = contentOffset.y
                let frameHeight = owner.scrollView.frame.size.height
                let shouldLoadMore = yOffset > (contentHeight-frameHeight) - 100
                
                if shouldLoadMore {
                    owner.loadMoreComments()
                }
            }.disposed(by: disposeBag)
    }
    
    private func updateEmptyLabelLayout() {
        if detailPostModelRelay.value.commentList.isEmpty && isLastPage {
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
        
        self.commentTableView.performBatchUpdates(nil, completion: nil)
        viewModel.requestCommentData(idx: self.postListModelRelay.value.idx)
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, size in
                owner.commentTableView.tableFooterView = nil
                if size != 10 {
                    self.isLastPage = true
                } else {
                    self.commentTableView.reloadData()
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindUI() {
        detailPostModelRelay
            .bind(with: self) { owner, commentModel in
                if commentModel.isMine {
                    owner.userOptionButton.isHidden = true
                } else {
                    owner.userOptionButton.snp.makeConstraints {
                        $0.centerY.equalTo(owner.userImageView)
                        $0.trailing.equalTo(owner.sharePostButton.snp.trailing).inset(45)
                    }
                }
                
                owner.userNameLabel.text = commentModel.writer
                
                guard let imageUrl = URL(string: commentModel.image ?? "") else {
                    return
                }
                
                Task {
                    guard let image = try? await Downsampling.optimization(
                        imageAt: imageUrl,
                        to: owner.userImageView.frame.size,
                        scale: UIScreen.main.scale
                    ) else { return }
                    owner.userImageView.image = image
                }
            }.disposed(by: disposeBag)
        
        enterCommentTextView.rx.didBeginEditing
            .filter { self.enterCommentTextView.text == CommentPlaceHolder.text }
            .bind(with: self) { owner, _ in
                owner.enterCommentTextView.text = ""
                owner.enterCommentTextView.textColor = .black
            }.disposed(by: disposeBag)
        
        enterCommentTextView.rx.didEndEditing
            .map { self.enterCommentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { $0.isEmpty }
            .bind(with: self) { owner, _ in
                owner.setEnterTextViewAutoSize()
                owner.enterCommentTextView.text = CommentPlaceHolder.text
                owner.enterCommentTextView.textColor = .lightGray
                owner.setDefaultSubmitButton()
            }.disposed(by: disposeBag)
        
        enterCommentTextView.rx.didChange
            .bind(with: self) { owner, _ in
                owner.setEnterTextViewAutoSize()
                
                if owner.enterCommentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count >= 1 {
                    owner.submitCommentButton.isEnabled = true
                    owner.submitCommentButton.setTitleColor(.blue, for: .normal)
                } else {
                    owner.setDefaultSubmitButton()
                }
            }.disposed(by: disposeBag)
        
        detailPostView.firstVoteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.updateVotingStateWithLayout(1)
            }.disposed(by: disposeBag)
        
        detailPostView.secondVoteButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.updateVotingStateWithLayout(2)
            }.disposed(by: disposeBag)
    }
    
    private func updateVotingStateWithLayout(_ votingState: Int) {
        let model = postListModelRelay.value
        
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
        
        detailPostView.updateVoteButtonsState(votingState: votingState)
        
        model.firstVotingCount = max(0, model.firstVotingCount)
        model.secondVotingCount = max(0, model.secondVotingCount)
        
        model.votingState = votingState
        viewModel.requestVote(idx: model.idx, choice: model.votingState)
        detailPostView.setVoteButton(with: model)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.commentTableView.addObserver(self, forKeyPath: ContentSizeKey.key, options: .new, context: nil)
        addUserDidTakeScreenshotNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.commentTableView.removeObserver(self, forKeyPath: ContentSizeKey.key)
        removeUserDidTakeScreenshotNotification()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
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
        detailPostView.configure(model: postListModelRelay.value)
        sharePostButtonDidTap()
    }
    
    override func addView() {
        view.addSubviews(
            scrollView, whiteBackgroundView
        )
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            userImageView, userNameLabel,
            userOptionButton, sharePostButton, detailPostView,
            divideCommentLineView, commentTableView
        )
        whiteBackgroundView.addSubviews(
            enterCommentTextView, submitCommentButton
        )
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
        
        detailPostView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.bottom.equalTo(divideCommentLineView.snp.top).offset(5)
            $0.top.equalTo(userImageView.snp.bottom).offset(5)
        }
        
        sharePostButton.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.trailing.equalTo(divideCommentLineView.snp.trailing)
        }
        
        divideCommentLineView.snp.makeConstraints {
            $0.top.equalTo(detailPostView.firstVoteButton.snp.bottom).offset(30)
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
        submitCommentButton.setTitleColor(DesignSystemAsset.Colors.grayDark.color, for: .normal)
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
        viewModel.requestToCreateComment(idx: postListModelRelay.value.idx, content: content)
            .bind(with: self) { owner, _ in
                var relay = owner.detailPostModelRelay.value
                relay.commentList.removeAll()
                owner.detailPostModelRelay.accept(relay)
                owner.loadMoreComments()
                owner.isLastPage = false
                DispatchQueue.main.async {
                    owner.commentTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                    owner.enterCommentTextView.text = nil
                    owner.enterCommentTextView.resignFirstResponder()
                    owner.setDefaultSubmitButton()
                    LoadingIndicator.hideLoading()
                }
            }.disposed(by: disposeBag)
    }
    
    private func submitCommentButtonDidTap() {
        submitCommentButton.rx.tap
            .bind(with: self) { owner, _ in
                LoadingIndicator.showLoading(text: "게시 중")
                owner.commentTableView.tableHeaderView = nil
                owner.submitComment()
            }.disposed(by: disposeBag)
    }
}

extension DetailPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var config: UISwipeActionsConfiguration? = nil
        
        let commentModel = detailPostModelRelay.value.commentList[indexPath.row]
        
        let deleteContextual = UIContextualAction(style: .destructive,
                                                  title: nil,
                                                  handler: { _, _, _ in
            self.viewModel.requestToDeleteComment(
                postIdx: self.postListModelRelay.value.idx,
                commentIdx: commentModel.idx
            )
            .bind(with: self) { owner, _ in
                LoadingIndicator.showLoading(text: "")
                var arr = owner.detailPostModelRelay.value
                arr.commentList.remove(at: indexPath.row)
                owner.detailPostModelRelay.accept(arr)
                DispatchQueue.main.async {
                    owner.commentTableView.reloadRows(
                        at: [indexPath],
                        with: .automatic
                    )
                }
                LoadingIndicator.hideLoading()
            }.disposed(by: self.disposeBag)
        })
        deleteContextual.image = UIImage(systemName: "trash")
        
        if commentModel.isMine {
            config = UISwipeActionsConfiguration(actions: [deleteContextual])
        }
        return config
    }
}
