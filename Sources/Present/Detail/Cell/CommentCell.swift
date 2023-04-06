import UIKit
import Then
import SnapKit
import Kingfisher

final class CommentCell: UITableViewCell {
    static let identifier = "CommentCellIdentifier"

    private let profileImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
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
        contentView.addSubviews(profileImageView, nicknameLabel, contentLabel)
    }

    private func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(32)
            $0.size.equalTo(25)
        }

        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}

extension CommentCell {
    func changeCommentData(model: CommentData) {
        self.nicknameLabel.text = model.nickname
        self.profileImageView.kf.setImage(with: URL(string: model.image))
        self.contentLabel.text = model.content
    }
}
