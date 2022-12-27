import UIKit

final class CommentCell: UITableViewCell {
    static let identifier = "CommentCellIdentifier"
    
    private let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
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
        self.backgroundColor = ChoiceAsset.Colors.mainBackgroundColor.color
        self.selectionStyle = .none
        
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        contentView.addSubviews(nicknameLabel, contentLabel, editButton, deleteButton)
    }
    
    private func setLayout() {
        
    }
}
