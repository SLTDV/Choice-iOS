import UIKit
import RxSwift
import RxCocoa
import Shared

enum PickerKey {
    static let first = "first"
    static let second = "second"
}

final class AddImageViewController: BaseVC<AddImageViewModel> {
    private let disposeBag = DisposeBag()
    
    private let addImageTitleLabel = UILabel().then {
        $0.text = "사진을 추가해주세요"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
    }
    
    private lazy var addFirstImageButton = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 30)
        $0.setTitleColor(SharedAsset.grayDark.color, for: .normal)
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
        $0.setTitleColor(SharedAsset.grayDark.color, for: .normal)
        $0.layer.cornerRadius = 10
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .init(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
        $0.addTarget(self, action: #selector(addSecondImageButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let firstImagePicker = UIImagePickerController().then {
        $0.restorationIdentifier = PickerKey.first
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }
    
    private let secondImagePicker = UIImagePickerController().then {
        $0.restorationIdentifier = PickerKey.second
        $0.sourceType = .photoLibrary
        $0.allowsEditing = true
    }
    
    private let topicTitleLabel = UILabel().then {
        $0.text = "사진 설명을 입력해주세요"
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .black
    }
    
    private lazy var firstSetTopicButton = UIButton().then {
        $0.setTitle("주제1", for: .normal)
        $0.tag = 0
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = SharedAsset.grayDark.color.cgColor
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(SetTopicButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private lazy var secondSetTopicButton = UIButton().then {
        $0.setTitle("주제2", for: .normal)
        $0.tag = 1
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = SharedAsset.grayDark.color.cgColor
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(SetTopicButtonDidTap(_:)), for: .touchUpInside)
    }
    
    private let addPostButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor( .white, for: .normal)
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 8
    }
    
    @objc private func addFirstImageButtonDidTap(_ sender: UIButton) {
        present(firstImagePicker, animated: true)
    }
    
    @objc private func addSecondImageButtonDidTap(_ sender: UIButton) {
        present(secondImagePicker, animated: true)
    }
    
    @objc private func SetTopicButtonDidTap(_ sender: UIButton) {
        let alert = UIAlertController(title: "주제", message: "주제를 입력해주세요.(1~8 글자)", preferredStyle: .alert)
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
    
    private func addPostButtonDidTap() {
        addPostButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.checkContents()
            }.disposed(by: disposeBag)
    }
    
    private func checkContents() {
        let alert = UIAlertController(title: "실패", message: "대표사진을 모두 등록해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))

        guard let firstImage = addFirstImageButton.imageView?.image else { return present(alert, animated: true) }
        guard let secondImage = addSecondImageButton.imageView?.image else { return present(alert, animated: true) }
        guard let firstVotingOption = firstSetTopicButton.titleLabel?.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let secondVotingOtion = secondSetTopicButton.titleLabel?.text?.trimmingCharacters(in: .whitespaces) else { return }
        if firstVotingOption.elementsEqual("주제1") || secondVotingOtion.elementsEqual("주제2") {
            alert.message = "주제를 입력해주세요."
            return present(alert, animated: true)
        }
        
        if (1...8).contains(firstVotingOption.count) && (1...8).contains(secondVotingOtion.count) {
            LoadingIndicator.showLoading(text: "게시 중")
            
            viewModel.createPost(
                firstImage: firstImage,
                secondImage: secondImage,
                firstVotingOption: firstVotingOption,
                secondVotingOtion: secondVotingOtion
            ) {
//                let customQueue = DispatchQueue(label: "dohyeon")
//                customQueue.sync {
                DispatchQueue.main.async {
                    AdvertismentsControl.shared.loadRewardedAd(vc: self)
                    
                }
//                    self.viewModel.pushComplteView()
                }
//            }
        } else {
            alert.message = "주제는 1~8 글자만 입력 가능합니다."
            return present(alert, animated: true)
        }
    }
    
    override func configureVC() {
        navigationItem.title = "게시물 작성"
        
        firstImagePicker.delegate = self
        secondImagePicker.delegate = self
        
        addPostButtonDidTap()
    }
    
    override func addView() {
        view.addSubviews(addImageTitleLabel, addFirstImageButton,addSecondImageButton,
                         topicTitleLabel, firstSetTopicButton,
                         secondSetTopicButton, addPostButton)
    }
    
    override func setLayout() {
        addImageTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.leading.equalToSuperview().inset(26)
        }
        
        addFirstImageButton.snp.makeConstraints {
            $0.top.equalTo(addImageTitleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(addImageTitleLabel.snp.leading)
            $0.width.equalToSuperview().dividedBy(2.77)
            $0.height.equalToSuperview().dividedBy(6.2)
        }
        
        addSecondImageButton.snp.makeConstraints {
            $0.top.equalTo(addImageTitleLabel.snp.bottom).offset(15)
            $0.trailing.equalToSuperview().inset(26)
            $0.width.equalToSuperview().dividedBy(2.77)
            $0.height.equalToSuperview().dividedBy(6.2)
        }
        
        topicTitleLabel.snp.makeConstraints {
            $0.top.equalTo(addFirstImageButton.snp.bottom).offset(35)
            $0.leading.equalTo(addFirstImageButton.snp.leading)
        }
        
        firstSetTopicButton.snp.makeConstraints {
            $0.top.equalTo(topicTitleLabel.snp.bottom).offset(15)
            $0.leading.equalTo(topicTitleLabel.snp.leading)
            $0.width.equalToSuperview().dividedBy(2.77)
            $0.height.equalToSuperview().dividedBy(10.4)
        }
        
        secondSetTopicButton.snp.makeConstraints {
            $0.top.equalTo(topicTitleLabel.snp.bottom).offset(15)
            $0.trailing.equalTo(addSecondImageButton.snp.trailing)
            $0.width.equalToSuperview().dividedBy(2.77)
            $0.height.equalToSuperview().dividedBy(10.4)
        }
        
        addPostButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets.bottom).inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.height.equalTo(58)
        }
    }
}

extension AddImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage
        }
        
        switch picker.restorationIdentifier {
        case PickerKey.first:
            self.addFirstImageButton.setImage(newImage, for: .normal)
        case PickerKey.second:
            self.addSecondImageButton.setImage(newImage, for: .normal)
        default:
            return
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
