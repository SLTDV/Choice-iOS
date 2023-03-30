import UIKit
import Then
import FlexLayout
import PinLayout

protocol CommentFuncProtocol: AnyObject {
    func deleteComment(commentIdx: Int)
}

final class CommentCell: UITableViewCell {
    static let identifier = "CommentCellIdentifier"
    
    weak var delegate: CommentFuncProtocol?
    
    private let rootContainer = UIView()
    
    private let profileImageView = UIImageView().then {
        $0.tintColor = .black
        $0.image = UIImage(systemName: "person.crop.circle.fill")
    }
    
    private let nicknameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private let contentLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        separatorInset = .zero
        
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        contentView.addSubview(rootContainer)
    }
    
    private func setLayout() {
        rootContainer.flex.define { flex in
            flex.addItem().direction(.row).padding(10, 32, 0).define { flex in
                flex.addItem(profileImageView).size(25).marginRight(6)
                flex.addItem(nicknameLabel).grow(1)
            }
            flex.addItem(contentLabel).margin(10, 32, 10)
        }
    }
    
    private func layout() {
        rootContainer.flex.layout(mode: .adjustHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rootContainer.pin.all()
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        rootContainer.pin.width(size.width)
        layout()
        return rootContainer.frame.size
    }
}

extension CommentCell {
    func changeCommentData(model: CommentData) {
        nicknameLabel.text = model.nickname
        contentLabel.text = model.content
        contentLabel.flex.markDirty()
        rootContainer.flex.layout()
    }
}
