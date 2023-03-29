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
        $0.text = "asdfafasfd\nasdfasdfasfasfasdf\nasdfasdfasdf"
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        
        addView()
        setLayout()
//        rootContainer.pin.all()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        contentView.addSubview(rootContainer)
    }
    
    private func setLayout() {
        rootContainer.flex.direction(.column).define { flex in
            flex.addItem().direction(.row).padding(10, 32, 15).define { flex in
                flex.addItem(profileImageView).size(25).marginRight(6)
                flex.addItem(nicknameLabel).minWidth(37).layout(mode: .adjustHeight)
            }
            flex.addItem(contentLabel).margin(0, 32, 10)
        }
    }
    
//    private func addView() {
//        contentView.addSubviews(profileImageView, nicknameLabel, contentLabel)
//    }
//
//    private func setLayout() {
//        profileImageView.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(10)
//            $0.leading.equalToSuperview().inset(32)
//            $0.size.equalTo(25)
//        }
//
//        nicknameLabel.snp.makeConstraints {
//            $0.centerY.equalTo(profileImageView)
//            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
//        }
//
//        contentLabel.snp.makeConstraints {
//            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
//            $0.leading.trailing.equalToSuperview().inset(32)
//            $0.bottom.equalToSuperview().inset(10)
//        }
//    }
    private func layout() {
        contentView.flex.layout(mode: .adjustHeight)
        rootContainer.flex.layout(mode: .adjustHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        rootContainer.pin.size(size)
        layout()
        return contentView.frame.size
    }
}

extension CommentCell {
    func changeCommentData(model: CommentData) {
        DispatchQueue.main.async {
            self.nicknameLabel.text = model.nickname
            self.contentLabel.text = model.content
            self.contentLabel.flex.layout(mode: .adjustHeight)
        }
    }
}
