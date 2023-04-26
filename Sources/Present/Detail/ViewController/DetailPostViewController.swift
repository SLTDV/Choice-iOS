import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class DetailPostViewController: BaseVC<DetailPostViewModel>, CommentDataProtocol {
    var writerNameData = PublishSubject<String>()
    var writerImageStringData = PublishSubject<String?>()
    var commentData = BehaviorRelay<[CommentData]>(value: [])
    private var model: Posts?
    var isLastPage = false
    
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
        $0.backgroundColor = ChoiceAsset.Colors.grayMedium.color
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.numberOfLines = 0
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
    
    private let firstVoteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let secondVoteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
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
        $0.backgroundColor = ChoiceAsset.Colors.grayMedium.color
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
        $0.isEnabled = false
        $0.setTitle("게시", for: .normal)
        $0.setTitleColor(ChoiceAsset.Colors.grayDark.color, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    private let commentTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 70
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMethod(_:)))
    
    init(viewModel: DetailPostViewModel, model: Posts) {
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
    
    @objc func keyboardUp(_ notification: NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown(_ notification: NSNotification) {
        self.view.transform = .identity
    }
    
    private func bindTableView() {
        commentData.bind(to: commentTableView.rx.items(cellIdentifier: CommentCell.identifier,
                                             cellType: CommentCell.self)) { (row, data, cell) in
            cell.changeCommentData(model: data)
        }.disposed(by: disposeBag)
        
        scrollView.rx.contentOffset
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, arg in
                let contentHeight = owner.scrollView.contentSize.height
                let yOffset = owner.scrollView.contentOffset.y
                let frameHeight = owner.scrollView.frame.size.height

                if owner.isLastPage {
                    return
                }
                
                if yOffset > (contentHeight-frameHeight) - 100 {
                    owner.commentTableView.tableFooterView = owner.createSpinnerFooter()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                        owner.commentTableView.performBatchUpdates(nil, completion: nil)
                        owner.viewModel.requestCommentData(idx: owner.model!.idx) { result in
                            owner.commentTableView.tableFooterView = nil
                            switch result {
                            case .success(let size):
                                owner.commentTableView.reloadData()
                                if size != 10 {
                                    owner.isLastPage = true
                                }
                            case .failure(let error):
                                print("comment pagination error = \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }).disposed(by: disposeBag)
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
                    owner.enterCommentTextView.text = "댓글을 입력해주세요."
                    owner.enterCommentTextView.textColor = UIColor.lightGray
                    owner.setDefaultSubmitButton()
                }
            }).disposed(by: disposeBag)
        
        enterCommentTextView.rx.didChange
            .bind(with: self, onNext: { owner, _ in
                let maxHeight = 94.0
                let fixedWidth = owner.enterCommentTextView.frame.size.width
                let size = owner.enterCommentTextView.sizeThatFits(CGSize(width: fixedWidth, height: .infinity))

                owner.enterCommentTextView.isScrollEnabled = size.height > maxHeight
                owner.enterCommentTextView.snp.updateConstraints {
                    $0.height.equalTo(min(maxHeight, size.height))
                }

                if owner.enterCommentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).count >= 1 {
                    owner.submitCommentButton.isEnabled = true
                    owner.submitCommentButton.setTitleColor(.blue, for: .normal)
                } else {
                    owner.setDefaultSubmitButton()
                }
            }).disposed(by: disposeBag)
    }
    
    private func submitComment() {
        guard let idx = model?.idx else { return }
        guard let content = enterCommentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        LoadingIndicator.showLoading(text: "게시 중")
        viewModel.commentCurrentPage = -1
        viewModel.requestToCreateComment(idx: idx, content: content) {
            DispatchQueue.main.async { [weak self] in
                self?.viewModel.requestCommentData(idx: idx)
                self?.commentTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .none, animated: true)
                self?.commentTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self?.commentData.accept([])
                self?.enterCommentTextView.text = ""
                self?.setDefaultSubmitButton()
            }
            LoadingIndicator.hideLoading()
        }
    }
    
    private func submitCommentButtonDidTap() {
        submitCommentButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.submitComment()
            }).disposed(by: disposeBag)
    }
    
    private func changePostData(model: Posts) {
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
    
    func setVoteButtonLayout(with model: Posts) {
        let data = CalculateToVoteCountPercentage.calculateToVoteCountPercentage(
            firstVotingCount: Double(model.firstVotingCount),
            secondVotingCount: Double(model.secondVotingCount)
        )
        firstVoteButton.setTitle("\(data.0)%(\(data.2)명)", for: .normal)
        secondVoteButton.setTitle("\(data.1)%(\(data.3)명)", for: .normal)
        votePostLayout(voting: model.votingState)
    }
    
    private func votePostLayout(voting: Int) {
        switch voting {
        case 1:
            firstVoteButton.backgroundColor = .black
            secondVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
        case 2:
            firstVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            secondVoteButton.backgroundColor = .black
        default:
            firstVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            secondVoteButton.backgroundColor = ChoiceAsset.Colors.grayDark.color
            firstVoteButton.setTitle("0%(0명)", for: .normal)
            secondVoteButton.setTitle("0%(0명)", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.commentTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.commentTableView.removeObserver(self, forKeyPath: "contentSize")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
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
        submitCommentButtonDidTap()
        changePostData(model: model!)
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
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(divideVotePostImageLineView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(43)
        }
        
        firstVoteOptionLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(firstPostImageView)
        }
        
        secondVoteOptionLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(40)
            $0.centerX.equalTo(secondPostImageView)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(firstVoteOptionLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(37)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(secondVoteOptionLabel.snp.bottom).offset(10)
            $0.trailing.equalToSuperview().inset(37)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        firstVoteButton.snp.makeConstraints {
            $0.top.equalTo(firstPostImageView.snp.bottom).offset(26)
            $0.leading.equalTo(firstPostImageView.snp.leading)
            $0.trailing.equalTo(firstPostImageView.snp.trailing)
            $0.height.equalTo(56)
        }
        
        secondVoteButton.snp.makeConstraints {
            $0.top.equalTo(secondPostImageView.snp.bottom).offset(26)
            $0.leading.equalTo(secondPostImageView.snp.leading)
            $0.trailing.equalTo(secondPostImageView.snp.trailing)
            $0.height.equalTo(56)
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
        submitCommentButton.setTitleColor(ChoiceAsset.Colors.grayDark.color, for: .normal)
    }
}

extension DetailPostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var config: UISwipeActionsConfiguration? = nil
        let commentModel = commentData.value[indexPath.row]
        
        lazy var deleteContextual = UIContextualAction(style: .destructive, title: nil, handler: { _, _, _ in
            self.viewModel.requestToDeleteComment(postIdx: self.model!.idx,
                                         commentIdx: commentModel.idx,
                                         completion: { [weak self] result in
                switch result {
                case .success(()):
                    self?.viewModel.requestCommentData(idx: self!.model!.idx)
                    DispatchQueue.main.async {
                        self?.commentTableView.reloadRows(
                            at: [indexPath],
                            with: .automatic
                        )
                    }
                case .failure(let error):
                    print("Delete Faield = \(error.localizedDescription)")
                }
            })
        })
        deleteContextual.image = UIImage(systemName: "trash")
        
        if commentModel.isMine {
            config = UISwipeActionsConfiguration(actions: [deleteContextual])
        }
        return config
    }
}
