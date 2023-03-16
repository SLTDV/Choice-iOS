import UIKit
import SnapKit
import Then

final class VoteOptionView: UIView {
    let voteOptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setLayout()
        
        layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMaxYCorner, .layerMaxXMaxYCorner)
        backgroundColor = .white
        layer.opacity = 0.85
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addView() {
        addSubview(voteOptionLabel)
    }
    
    private func setLayout() {
        voteOptionLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setVoteOptionLabel(_ text: String) {
        voteOptionLabel.text = text
    }
}
