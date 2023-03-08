import UIKit
import SnapKit
import Then
import Kingfisher

final class PostCell: UITableViewCell {
    static let identifier = "PostCellIdentifier"
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = .systemFont(ofSize: 12)
    }
    
    private let firstPostImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private let secondPostImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        
        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
    }
    
    private func addView() {
        contentView.addSubviews(titleLabel, descriptionLabel, firstPostImageView, secondPostImageView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(31)
            $0.leading.equalToSuperview().inset(23)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(23)
        }
        
        firstPostImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).inset(24)
            $0.leading.equalToSuperview().inset(21)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
        
        secondPostImageView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).inset(24)
            $0.trailing.equalToSuperview().inset(21)
            $0.width.equalTo(134)
            $0.height.equalTo(145)
        }
    }
    
    func changeCellData(with model: PostModel) {
        DispatchQueue.main.async {
            self.titleLabel.text = model.title
            self.descriptionLabel.text = model.content
            if let imageUrl = URL(string: model.thumbnail) {
                self.firstPostImageView.kf.setImage(with: imageUrl)
            }
        }
    }
}
