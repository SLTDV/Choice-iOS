import UIKit
import PhotosUI
import Alamofire
import RxSwift

final class AddPostViewController: BaseVC<AddPostViewModel> {
    private lazy var addMainImageButton = UIButton().then {
        $0.addTarget(self, action: #selector(addImageButtonDidTap(_:)), for: .touchUpInside)
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    private let plusIconImageView = UIImageView().then {
        $0.image = .init(systemName: "plus")
        $0.tintColor = .gray
        $0.contentMode = .scaleAspectFill
    }
    
    private let imagePicker = UIImagePickerController().then {
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }
    
    private let inputTitleTextField = UITextField().then {
        $0.placeholder = "제목입력"
        $0.textColor = .lightGray
        $0.borderStyle = .none
    }
    
    private let divideLine = UIView().then {
        $0.backgroundColor = .init(red: 0.37, green: 0.36, blue: 0.36, alpha: 1)
    }
    
    private let inputDescriptionTextView = UITextView().then {
        $0.text = "내용입력"
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .lightGray
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 1
        $0.layer.borderColor = .init(red: 0.629, green: 0.629, blue: 0.629, alpha: 1)
    }
    
    private let topicTitleLabel = UILabel().then {
        $0.text = "주제를 입력해주세요"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
    }
    
    private lazy var firstSetTopicButton = UIButton().then {
        $0.addTarget(self, action: #selector(SetTopicButtonDidTap(_:)), for: .touchUpInside)
        $0.tag = 0
        $0.setTitle("주제1", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = .init(red: 0.629, green: 0.629, blue: 0.629, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    private lazy var secondSetTopicButton = UIButton().then {
        $0.addTarget(self, action: #selector(SetTopicButtonDidTap(_:)), for: .touchUpInside)
        $0.tag = 1
        $0.setTitle("주제2", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = .init(red: 0.629, green: 0.629, blue: 0.629, alpha: 1)
        $0.layer.cornerRadius = 8
    }
    
    private lazy var addPostViewButton = UIButton().then {
        $0.addTarget(self, action: #selector(addPostViewButtonDidTap(_:)), for: .touchUpInside)
        $0.setTitle("계속", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    @objc private func addImageButtonDidTap(_ sender: UIButton) {
        self.present(imagePicker, animated: true)
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
        guard let title = inputTitleTextField.text else { return }
        guard let content = inputDescriptionTextView.text else { return }
        guard let thumbnail = addMainImageButton.imageView?.image else { return }
        guard let firstVotingOption = firstSetTopicButton.titleLabel?.text else { return }
        guard let secondVotingOtion = secondSetTopicButton.titleLabel?.text else { return }
        
        viewModel.createPost(title: title, content: content, imageData: thumbnail, firstVotingOption: firstVotingOption, secondVotingOtion: secondVotingOtion)
    }
    
    override func configureVC() {
        navigationItem.title = "게시물 작성"
        
        inputDescriptionTextView.delegate = self
        imagePicker.delegate = self
    }
    
    override func addView() {
        view.addSubviews(addMainImageButton, plusIconImageView, inputTitleTextField, divideLine, inputDescriptionTextView,
                         topicTitleLabel, firstSetTopicButton, secondSetTopicButton, addPostViewButton)
    }
    
    override func setLayout() {
        addMainImageButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(99)
            $0.height.equalTo(223)
            $0.leading.trailing.equalToSuperview()
        }
        
        plusIconImageView.snp.makeConstraints {
            $0.height.equalTo(25)
            $0.center.equalTo(addMainImageButton)
        }
        
        inputTitleTextField.snp.makeConstraints {
            $0.top.equalTo(addMainImageButton.snp.bottom).offset(36)
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
            $0.bottom.equalToSuperview().inset(39)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(49)
        }
    }
}

extension AddPostViewController: UITextViewDelegate {
    
    private func setTextViewPlaceholder() {
        if inputDescriptionTextView.text.isEmpty {
            inputDescriptionTextView.text = "내용입력"
            inputDescriptionTextView.textColor = UIColor.lightGray
        } else if inputDescriptionTextView.text == "내용입력"{
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
        
        self.addMainImageButton.setImage(newImage, for: .normal)
        picker.dismiss(animated: true, completion: nil)
    }
}
