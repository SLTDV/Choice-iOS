import UIKit
import RxSwift
import RxCocoa
import Shared

final class AddPostViewController: BaseVC<AddPostViewModel> {
    private let disposeBag = DisposeBag()

    private let inputTitleTextField = BoxTextField(type: .countTextField).then {
        $0.placeholder = "제목입력 (2~16)"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let divideLine = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let inputDescriptionTextView = UITextView().then {
        $0.text = "내용입력 (0~100)"
        $0.textContainerInset = UIEdgeInsets(top: 18, left: 8, bottom: 18, right: 8)
        $0.textColor = .placeholderText
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = SharedAsset.grayMedium.color.cgColor
    }
    
    private let textCountLabel = UILabel().then {
        $0.text = "(0/100)"
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .placeholderText
    }
    
    private lazy var addPostViewButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.backgroundColor = SharedAsset.grayMedium.color
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
    }
    
    private func bindUI() {
        let titleTextObservable = inputTitleTextField.rx.text.orEmpty
        let descriptionTextObservable = inputDescriptionTextView.rx.text.orEmpty
            .filter { $0 != "내용입력 (0~100)" }
        
        Observable.combineLatest(
            titleTextObservable,
            descriptionTextObservable,
            resultSelector: { s1, s2 in (2...16).contains(s1.count) && (2...100).contains(s2.count) }
        )
        .bind(with: self, onNext: { owner, arg in
            owner.addPostViewButton.isEnabled = arg
            owner.addPostViewButton.backgroundColor = arg ? .black : SharedAsset.grayMedium.color
        }).disposed(by: disposeBag)
    }
    
    private func bindCountTextLabel() {
        inputDescriptionTextView.rx.text
            .orEmpty
            .filter { $0 != "내용입력 (0~100)" }
            .map { text in
                let count = text.count
                return "(\(count)/100)"
            }
            .bind(to: textCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func textSetUp(){
        inputDescriptionTextView.rx.didBeginEditing
                .subscribe(onNext: { [self] in
                if(inputDescriptionTextView.text == "내용입력 (0~100)"){
                    inputDescriptionTextView.text = nil
                    inputDescriptionTextView.textColor = .black
                }}).disposed(by: disposeBag)
            
        inputDescriptionTextView.rx.didEndEditing
                .subscribe(onNext: { [self] in
                if(inputDescriptionTextView.text == nil || inputDescriptionTextView.text == ""){
                    inputDescriptionTextView.text = "내용입력 (0~100)"
                    inputDescriptionTextView.textColor = .placeholderText
                }}).disposed(by: disposeBag)
        }
    
    override func configureVC() {
        navigationItem.title = "게시물 작성"
        let backBarButtonItem = UIBarButtonItem(title: "dasd", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        textSetUp()
        bindCountTextLabel()
        bindUI()
    }
    
    override func addView() {
        view.addSubviews(inputTitleTextField, divideLine,
                         inputDescriptionTextView, textCountLabel, addPostViewButton)
    }
    
    override func setLayout() {
        inputTitleTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(42)
            $0.height.equalTo(58)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        inputDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(inputTitleTextField.snp.bottom).offset(25)
            $0.height.equalTo(150)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        textCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(inputDescriptionTextView.snp.trailing).inset(10)
            $0.bottom.equalTo(inputDescriptionTextView.snp.bottom).inset(10)
        }
        
        addPostViewButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(49)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
