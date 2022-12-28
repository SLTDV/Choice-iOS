import UIKit

final class CommentCell: UITableViewCell {
    static let identifier = "CommentCellIdentifier"
    
    private let nicknameLabel = UILabel().then {
        $0.text = "dsadada"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "dsadasdasdasdasd"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    private let editButton = UIButton().then {
        $0.isHidden = true
    }
    
    private let deleteButton = UIButton().then {
        $0.isHidden = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .lightGray
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
        contentView.addSubviews(nicknameLabel, contentLabel, editButton, deleteButton)
    }
    
    private func setLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(5)
            $0.leading.equalToSuperview().offset(10)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
        }
        
    }
}
