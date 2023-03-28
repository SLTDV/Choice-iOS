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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = ChoiceAsset.Colors.grayBackground.color
        selectionStyle = .none
        
        addView()
        setLayout()
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 18, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        contentView.addSubviews(profileImageView, nicknameLabel, contentLabel)
    }
    
    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.size.equalTo(25)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
    
    func changeCommentData(model: CommentData) {
        DispatchQueue.main.async {
            self.commentIdx = model.idx
            self.nicknameLabel.text = model.nickname
            self.contentLabel.text = model.content
        }
    }
}
