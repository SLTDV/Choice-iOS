import UIKit
import SnapKit
import Then
import Lottie

public class CompleteViewController: UIViewController {
    private var text: String
    
    private let animationView = LottieAnimationView(name: "CompleteLottie").then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let completeLabel = UILabel()
    
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
        
        animationView.play { (finished) in
            if finished {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
