import UIKit
import Shared

class ChangePasswordViewController: BaseVC<ChangePasswordViewModel> {
    let component = InputPasswordComponent()
    
    override func configureVC() {
        
    }
    
    override func addView() {
        view.addSubview(component)
    }
    
    override func setLayout() {
        component.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
