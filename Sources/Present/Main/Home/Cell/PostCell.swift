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
        
    private let postImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private let voteView = VoteView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
        self.backgroundColor = ChoiceAsset.Colors.mainBackgroundColor.color
        self.selectionStyle = .none
        
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
        contentView.addSubviews(titleLabel, descriptionLabel, postImageView, voteView)
    }
    
    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        postImageView.snp.makeConstraints {
            $0.bottom.equalTo(voteView.snp.top).offset(-10)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        voteView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func changeCellData(with model: [PostModel]) {
        DispatchQueue.main.async {
            self.titleLabel.text = model[0].title
            self.descriptionLabel.text = model[0].content
            if let imageUrl = URL(string: model[0].thumbnail) {
                self.postImageView.kf.setImage(with: imageUrl)
            }
        }
        voteView.changeVoteTitleData(with: model)
    }
}
