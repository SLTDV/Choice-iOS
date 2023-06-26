import UIKit
import SnapKit
import Then
import Shared

class BaseVC<T: BaseViewModel>: UIViewController {
    let bound = UIScreen.main.bounds
    
    let viewModel: T
    
    init(viewModel: T){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @available(*, unavailable)
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = SharedAsset.grayDark.color
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        setup()
        addView()
        setLayout()
        configureVC()
        addUserDidTakeScreenshotNotification()
    }
    
    @available(*, unavailable)
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.coordinator.didFinish(coordinator: viewModel.coordinator)
    }
    
    deinit{
        print("\(type(of: self)): \(#function)")
    }
    
    func setup(){}
    func addView(){}
    func setLayout(){}
    func configureVC(){}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addUserDidTakeScreenshotNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didDetchScreenshot),
            name: UIApplication.userDidTakeScreenshotNotification, object: nil
        )
    }
    
    @objc func didDetchScreenshot() {
        let alert = UIAlertController(title: "경고", message: "게시물에 사진을 온/오프라인에 부적절한 용도로 유포할 경우 법적 제재를 받을 수 있습니다.", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
}
