import UIKit

final class DetailPostViewController: BaseVC<DetailPostViewModel> {
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
    }
    
    private let postImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.contentMode = .scaleToFill
    }
    
    private let voteView = VoteView()
    
    private let divideLineView = UIView().then {
        $0.backgroundColor = .init(red: 0.37, green: 0.36, blue: 0.36, alpha: 1)
    }
    
    private let commentCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
    }
    
    override func addView() {
        view.addSubviews(titleLabel, descriptionLabel, postImageView, voteView, divideLineView)
    }
}
