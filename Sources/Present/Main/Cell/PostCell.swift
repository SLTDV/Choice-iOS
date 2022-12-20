import UIKit
import SnapKit
import Then

class PostCell: UITableViewCell {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12)
    }
        
    private let postImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleAspectFit
    }
    
    private let voteView = VoteView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        contentView.addSubviews(titleLabel, descriptionLabel, postImageView, voteView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        postImageView.snp.makeConstraints {
            $0.bottom.equalTo(voteView.snp.top).offset(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        voteView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
