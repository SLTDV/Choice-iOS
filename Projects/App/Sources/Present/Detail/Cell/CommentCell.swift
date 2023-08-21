import UIKit
import Then
import SnapKit
import Shared

final class CommentCell: UITableViewCell {
    static let identifier = "CommentCellIdentifier"
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .black
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
            $0.leading.equalToSuperview().inset(30)
            $0.size.equalTo(25)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(33)
            $0.bottom.equalToSuperview().inset(10)
        }
    }
}

extension CommentCell {
    func configure(model: CommentList) {
        self.nicknameLabel.text = model.nickname
        self.contentLabel.text = model.content
        guard let profileImageUrl = URL(string: model.profileImageUrl ?? "") else {
            return
        }
        Downsampling.optimization(imageAt: profileImageUrl,
                                  to: profileImageView.frame.size,
                                  scale: 2) { [weak self] image in
            self?.profileImageView.image = image
        }
    }
}
