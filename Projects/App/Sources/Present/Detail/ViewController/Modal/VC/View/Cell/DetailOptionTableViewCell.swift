import UIKit
import Then
import SnapKit

final class DetailOptionTableViewCell: UITableViewCell {
    static let identifier = "DetailOptionTableCellIdentifier"
    
    private let optionIconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }

    private let optionTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: [MyData]) {
        optionIconImageView.image = data[0].image
        optionIconImageView.tintColor = data[0].color
        
        optionTitleLabel.text = data[0].text
        optionTitleLabel.textColor = data[0].color
    }
    
    private func addView() {
        contentView.addSubviews(optionIconImageView, optionTitleLabel)
    }
    
    private func setLayout() {
        optionIconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(40)
            $0.width.equalToSuperview().dividedBy(15.6)
            $0.height.equalToSuperview().dividedBy(9)
        }
        
        optionTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(optionIconImageView)
            $0.left.equalTo(optionIconImageView.snp.right).offset(14)
            $0.height.equalTo(40)
        }
    }
}
