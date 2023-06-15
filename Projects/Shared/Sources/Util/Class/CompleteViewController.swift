import UIKit
import SnapKit
import Then
import Lottie

public class CompleteViewController: UIViewController {
    private var text: String
    
    private let animationView = LottieAnimationView().then {
        $0.animation = LottieAnimation.named("CompleteLottie")
        $0.contentMode = .scaleAspectFit
        $0.play()
    }
    
    public init(text: String) {
        self.text = text
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        view.backgroundColor = .white

        view.addSubview(animationView)
        animationView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(326)
        }
    }
}
