import UIKit
import SnapKit
import Lottie

public class CompleteViewController: UIViewController {
    private var text: String
    
    private let animationView: LottieAnimationView = {
       let lottieView = LottieAnimationView(name: "lottieFile")
       lottieView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
       return lottieView
    }()
    
    public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
