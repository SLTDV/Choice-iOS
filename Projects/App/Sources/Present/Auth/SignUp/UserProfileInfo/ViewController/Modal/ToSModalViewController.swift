import UIKit
import SafariServices
import SnapKit
import Then
import RxSwift
import RxCocoa
import Shared

protocol ToSModalViewControllerDelegate: AnyObject {
    func UpButtonDidTap()
}

final class ToSModalViewController: UIViewController, AgreementComponentViewDelegate {
    private let disposeBag = DisposeBag()
    
    weak var delegate: ToSModalViewControllerDelegate?
    
    private let privacyPolicyUrl = NSURL(string: "https://opaque-plate-ed2.notion.site/aa6adde3d5cf4836847f8fc79a6cc3cf")
    
    private let allAgreementButton = UIButton().then {
        $0.tintColor = .gray
        $0.setImage(UIImage(systemName: "checkmark.square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
    }
    
    private let allAgreementLabel = UILabel().then {
        $0.text = "전체동의"
        $0.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private let divideLineView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let agreeToSView = AgreementComponentView().then {
        $0.setOptionLabel("[필수] 이용약관")
    }
    
    private let agreeInfoView = AgreementComponentView().then {
        $0.setOptionLabel("[필수] 개인정보 수집 동의")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        agreeToSView.delegate = self
        agreeInfoView.delegate = self
        
        allAgreeButtonDidTap()
        addView()
        setLayout()
    }
    
    private func allAgreeButtonDidTap() {
        allAgreementButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.allAgreementButton.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
                owner.allAgreementButton.tintColor = .black
                
                owner.agreeToSView.setCheckButton()
                owner.agreeInfoView.setCheckButton()
                
                owner.dismiss(animated: true) {
                    owner.delegate?.UpButtonDidTap()
                }
            }.disposed(by: disposeBag)
    }
    
    func agreementComponentViewDidTapLinkButton(_ view: AgreementComponentView) {
            let privacyPolicyView = SFSafariViewController(url: privacyPolicyUrl! as URL)
            present(privacyPolicyView, animated: true)
    }
    
    private func addView() {
        view.addSubviews(allAgreementButton, allAgreementLabel, divideLineView, agreeToSView, agreeInfoView)
    }
    
    private func setLayout() {
        allAgreementButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(44)
            $0.leading.equalToSuperview().offset(35)
        }
        
        allAgreementLabel.snp.makeConstraints {
            $0.centerY.equalTo(allAgreementButton)
            $0.leading.equalTo(allAgreementButton.snp.trailing).offset(15)
        }
        
        divideLineView.snp.makeConstraints {
            $0.top.equalTo(allAgreementButton.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.height.equalTo(1)
        }
        
        agreeToSView.snp.makeConstraints {
            $0.top.equalTo(divideLineView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.height.equalTo(40)
        }
        
        agreeInfoView.snp.makeConstraints {
            $0.top.equalTo(agreeToSView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(35)
            $0.height.equalTo(40)
        }
    }
}
