import UIKit
import PhotosUI
import RxSwift
import RxCocoa

final class AddPostViewController: BaseVC<AddPostViewModel> {
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }

    private let contentView = UIView()
    
    private let addImageTitleLabel = UILabel().then {
        $0.text = "대표 사진을 설정해주세요. (필수)"
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    private lazy var addFirstImageButton = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 30)
        $0.setTitleColor(ChoiceAsset.Colors.grayDark.color, for: .normal)
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addTarget(self, action: #selector(addFirstImageButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private lazy var addSecondImageButton = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 30)
        $0.setTitleColor(ChoiceAsset.Colors.grayDark.color, for: .normal)
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addTarget(self, action: #selector(addSecondImageButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let firstImagePicker = UIImagePickerController().then {
        $0.restorationIdentifier = "first"
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }
    
    private let secondImagePicker = UIImagePickerController().then {
        $0.restorationIdentifier = "second"
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }
    
    private let inputTitleTextField = UITextField().then {
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.placeholder = "제목입력 (2~16)"
        $0.textColor = .lightGray
        $0.borderStyle = .none
    }
    
    private let divideLine = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let inputDescriptionTextView = UITextView().then {
        $0.text = "내용입력 (20~100)"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .lightGray
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
    }
    
    private let topicTitleLabel = UILabel().then {
        $0.text = "주제를 입력해주세요. (필수)"
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .black
    }
    
    private lazy var firstSetTopicButton = UIButton().then {
        $0.setTitle("주제1 ✏️", for: .normal)
        $0.tag = 0
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(SetTopicButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private lazy var secondSetTopicButton = UIButton().then {
        $0.setTitle("주제2 ✏️", for: .normal)
        $0.tag = 1
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = ChoiceAsset.Colors.grayDark.color.cgColor
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(SetTopicButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private lazy var addPostViewButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.backgroundColor = ChoiceAsset.Colors.grayMedium.color
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(addPostViewButtonDidTap(_:)), for: .touchUpInside)
    }
    
    @objc private func tapMethod(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapMethod(_:)))
    
    private func bindUI() {
        let titleTextObservable = inputTitleTextField.rx.text.filter { $0!.count < 20 }
        let descriptionTextObservable = inputDescriptionTextView.rx.text.filter { $0!.count < 100 }
        
        Observable.combineLatest(
            titleTextObservable,
            descriptionTextObservable,
            resultSelector: { s1, s2 in (s1!.count > 2) && (s2!.count > 20) }
        )
        .subscribe(with: self, onNext: { owner, arg in
            owner.addPostViewButton.isEnabled = arg
            owner.addPostViewButton.backgroundColor = arg ? .black : ChoiceAsset.Colors.grayMedium.color
        }).disposed(by: disposeBag)
    }
    
    @objc private func addFirstImageButtonDidTap(_ sender: UIButton) {
        present(firstImagePicker, animated: true)
    }
    
    @objc private func addSecondImageButtonDidTap(_ sender: UIButton) {
        present(secondImagePicker, animated: true)
    }
    
    @objc private func SetTopicButtonDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "주제", message: "주제를 입력해주세요.", preferredStyle: .alert)
        alert.addTextField()
        
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            switch sender.tag {
            case 0:
                self?.firstSetTopicButton.setTitle(alert.textFields?[0].text, for: .normal)
            case 1:
                self?.secondSetTopicButton.setTitle(alert.textFields?[0].text, for: .normal)
            default:
                return
            }
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
    }
    
    @objc private func addPostViewButtonDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "실패", message: "대표사진을 모두 등록해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        
        guard let title = inputTitleTextField.text else { return }
        guard let content = inputDescriptionTextView.text else { return }
        guard let firstImage = addFirstImageButton.imageView?.image else { return present(alert, animated: true) }
        guard let secondImage = addSecondImageButton.imageView?.image else { return present(alert, animated: true) }
        guard let firstVotingOption = firstSetTopicButton.titleLabel?.text else { return }
        guard let secondVotingOtion = secondSetTopicButton.titleLabel?.text else { return }
        if firstVotingOption.elementsEqual("주제1 ✏️") || secondVotingOtion.elementsEqual("주제2 ✏️") {
            alert.message = "주제를 입력해주세요."
            return present(alert, animated: true)
        }

        viewModel.createPost(title: title, content: content, firstImage: firstImage, secondImage: secondImage, firstVotingOption: firstVotingOption, secondVotingOtion: secondVotingOtion)
        LoadingIndicator.showLoading(text: "게시 중")
    }
    
    override func configureVC() {
        navigationItem.title = "게시물 작성"
        
        inputDescriptionTextView.delegate = self
        firstImagePicker.delegate = self
        secondImagePicker.delegate = self
        scrollView.addGestureRecognizer(tapGestureRecognizer)
        
        bindUI()
    }
    
    override func addView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(addImageTitleLabel, addFirstImageButton,
                                addSecondImageButton, inputTitleTextField, divideLine,
                                inputDescriptionTextView, topicTitleLabel, firstSetTopicButton,
                                secondSetTopicButton, addPostViewButton)
    }
    
    override func setLayout() {
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.centerX.width.top.bottom.equalToSuperview()
        }

        addImageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets).inset(30)
            $0.leading.equalToSuperview().inset(33)
        }
        
        addFirstImageButton.snp.makeConstraints {
            $0.top.equalTo(addImageTitleLabel.snp.bottom).offset(16)
            $0.size.equalTo(130)
            $0.leading.equalToSuperview().inset(32)
        }
        
        addSecondImageButton.snp.makeConstraints {
            $0.top.equalTo(addImageTitleLabel.snp.bottom).offset(16)
            $0.size.equalTo(130)
            $0.trailing.equalToSuperview().inset(32)
        }
        
        inputTitleTextField.snp.makeConstraints {
            $0.top.equalTo(addFirstImageButton.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        divideLine.snp.makeConstraints {
            $0.top.equalTo(inputTitleTextField.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        inputDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(divideLine.snp.bottom).offset(20)
            $0.height.equalTo(130)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        topicTitleLabel.snp.makeConstraints {
            $0.top.equalTo(inputDescriptionTextView.snp.bottom).offset(35)
            $0.leading.equalToSuperview().offset(32)
        }
        
        firstSetTopicButton.snp.makeConstraints {
            $0.top.equalTo(topicTitleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(32)
            $0.trailing.equalToSuperview().inset(211)
            $0.height.equalTo(89)
        }
        
        secondSetTopicButton.snp.makeConstraints {
            $0.top.equalTo(topicTitleLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().inset(211)
            $0.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(89)
        }
        
        addPostViewButton.snp.makeConstraints {
            $0.top.equalTo(firstSetTopicButton.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(49)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

extension AddPostViewController: UITextViewDelegate {
    private func setTextViewPlaceholder() {
        if inputDescriptionTextView.text.isEmpty {
            inputDescriptionTextView.text = "내용입력 (20~100)"
            inputDescriptionTextView.textColor = UIColor.lightGray
        } else if inputDescriptionTextView.text == "내용입력 (20~100)" {
            inputDescriptionTextView.text = ""
            inputDescriptionTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        setTextViewPlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setTextViewPlaceholder()
        }
    }
}

extension AddPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        switch picker.restorationIdentifier {
        case "first":
            self.addFirstImageButton.setImage(newImage, for: .normal)
        case "second":
            self.addSecondImageButton.setImage(newImage, for: .normal)
        default:
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
