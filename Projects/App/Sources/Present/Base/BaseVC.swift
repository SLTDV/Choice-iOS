import UIKit
import SnapKit
import Then
import DesignSystem

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
        backBarButtonItem.tintColor = DesignSystemAsset.Colors.grayDark.color
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        setup()
        addView()
        setLayout()
        configureVC()
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
}
