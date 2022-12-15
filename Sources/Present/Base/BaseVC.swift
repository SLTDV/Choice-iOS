import UIKit

class BaseVC<T: BaseViewModel>: UIViewController{
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
        setup()
        addView()
        setLayout()
        configureVC()
        bindVM()
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
    func bindVM(){}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
