import UIKit
import Alamofire
import JwtStore
import Swinject

final class AddImageViewModel: BaseViewModel {
    var title = ""
    var content = ""
    
    init(coordinator: AddImageCoordiantor, title: String, content: String) {
        super.init(coordinator: coordinator)
        self.title = title
        self.content = content
    }
    
    func createPost(
        firstImage: UIImage,
        secondImage: UIImage,
        firstVotingOption: String,
        secondVotingOtion: String,
        completion: @escaping () -> Void
    ) {
        var url = APIConstants.postImageUploadURL
        var headers: HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        
        AF.upload(multipartFormData: { multipartFormData in
            if let image = firstImage.pngData() {
                multipartFormData.append(image, withName: "firstImage", fileName: "\(image).png", mimeType: "image/png")
            }
            if let image = secondImage.pngData() {
                multipartFormData.append(image, withName: "secondImage", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: url,
           method: .post,
           headers: headers,
           interceptor: JwtRequestInterceptor(
           jwtStore: DIContainer.shared.resolve(JwtStore.self)!)
        )
        .validate()
        .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(AddPostModel.self, from: data)
                let firstImageUrl = decodeResponse?.firstUploadImageUrl ?? ""
                let secondImageUrl = decodeResponse?.secondUploadImageUrl ?? ""
                
                headers = ["Content-Type": "application/json"]
                url = APIConstants.createPostURL
                let params = [
                    "title" : self?.title,
                    "content" : self?.content,
                    "firstVotingOption" : firstVotingOption,
                    "secondVotingOption" : secondVotingOtion,
                    "firstImageUrl" : firstImageUrl,
                    "secondImageUrl" : secondImageUrl
                ]
                
                AF.request(url,
                           method: .post,
                           parameters: params,
                           encoding: JSONEncoding.default,
                           headers: headers,
                           interceptor: JwtRequestInterceptor(jwtStore: DIContainer.shared.resolve(JwtStore.self)!))
                .validate()
                .responseData(emptyResponseCodes: [200, 201, 204]) { response in
                    switch response.result {
                    case .success:
                        completion()
                    case .failure(let error):
                        print("post error = \(String(describing: error.localizedDescription))")
                    }
                }
            case .failure(let error):
                print("upload error \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    func pushComplteView() {
        coordinator.navigate(to: .pushCompleteViewIsRequired)
    }
}
