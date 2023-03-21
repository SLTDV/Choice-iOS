import UIKit

protocol CommentFuncProtocol: AnyObject {
    func deleteComment(commentIdx: Int)
}

final class CommentCell: UITableViewCell {
    static let identifier = "CommentCellIdentifier"
    
    weak var delegate: CommentFuncProtocol?
    
    private var commentIdx: Int = 0
    
    private let profileImageView = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private let editButton = UIButton().then {
        $0.setTitleColor(.init(red: 0.629, green: 0.629, blue: 0.629, alpha: 1), for: .normal)
        $0.setTitle("수정", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.isHidden = true
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitleColor(.init(red: 0.629, green: 0.629, blue: 0.629, alpha: 1), for: .normal)
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .init(red: 0.929, green: 0.929, blue: 0.929, alpha: 1)
        self.selectionStyle = .none
        
        addView()
        setLayout()
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        contentView.addSubviews(profileImageView, nicknameLabel,
                                contentLabel, editButton, deleteButton)
    }
    
    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.size.equalTo(25)
            $0.leading.equalToSuperview().offset(10)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(10)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalTo(deleteButton.snp.leading).offset(-15)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    func changeCommentData(model: [CommentData]) {
        DispatchQueue.main.async {
            self.commentIdx = model[0].idx
            self.nicknameLabel.text = model[0].nickname
            self.contentLabel.text = model[0].content
        }
    }
}
