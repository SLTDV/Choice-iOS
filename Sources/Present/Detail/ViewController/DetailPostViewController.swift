import UIKit

final class DetailPostViewController: BaseVC<DetailPostViewModel> {
    var cellData = ["dsadas","dasd"]
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
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
    
    override func addView() {
        view.addSubviews(titleLabel, descriptionLabel, postImageView, voteView, divideLineView)
    }
    
    override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(107)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
        }
        
        postImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        voteView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        divideLineView.snp.makeConstraints {
            $0.top.equalTo(voteView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(1)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.top.equalTo(divideLineView.snp.bottom).offset(18)
        }
        enterCommentTextView.snp.makeConstraints {
            $0.top.equalTo(commentCountLabel.snp.bottom).offset(18)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier, for: indexPath) as? CommentCell else { return UITableViewCell() }

        cell.selectionStyle = .none

        return cell
    }
}
