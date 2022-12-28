import UIKit

final class DetailPostViewController: BaseVC<DetailPostViewModel> {
    var cellData = ["dsadas","dasd"]
    
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "adad"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "dasdasdasda"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private let postImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private let voteView = VoteView()
    
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
    
    private let commentTableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
    }
    
    override func configureVC() {
        commentTableView.dataSource = self
        enterCommentTextView.delegate = self
        scrollView.delegate = self
        
        commentTableView.rowHeight = 160
    }
    
    override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, descriptionLabel, postImageView, voteView, divideLineView, commentCountLabel, enterCommentTextView, commentTableView)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(view.snp.height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
        }

        postImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }

        voteView.snp.makeConstraints {
            $0.top.equalTo(postImageView.snp.bottom).offset(31)
            $0.centerX.equalToSuperview()
        }

        divideLineView.snp.makeConstraints {
            $0.top.equalTo(voteView.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(1)
        }

        commentCountLabel.snp.makeConstraints {
            $0.top.equalTo(divideLineView.snp.bottom).offset(18)
            $0.leading.equalToSuperview().offset(30)
        }
        
        enterCommentTextView.snp.makeConstraints {
            $0.top.equalTo(commentCountLabel.snp.bottom).offset(18)
            $0.height.equalTo(83)
            $0.leading.trailing.equalToSuperview().inset(30)
        }

        commentTableView.snp.makeConstraints {
            $0.top.equalTo(enterCommentTextView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalToSuperview()
        }
    }
}

extension DetailPostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UITableViewCell() }

        cell.selectionStyle = .none

        return cell
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
