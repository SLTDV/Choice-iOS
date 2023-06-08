import UIKit
import Alamofire
import Shared
import JwtStore
import Swinject

final class AddContentsViewModel: BaseViewModel {
    func createPost(title: String, content: String, firstImage: UIImage, secondImage: UIImage,
                    firstVotingOption: String, secondVotingOtion: String) {
        var url = APIConstants.postImageUploadURL
        var headers: HTTPHeaders = ["Content-Type" : "multipart/form-data"]

        AF.upload(multipartFormData: { multipartFormData in
            if let image = firstImage.pngData() {
                multipartFormData.append(image, withName: "firstImage", fileName: "\(image).png", mimeType: "image/png")
            }
            if let image = secondImage.pngData() {
                multipartFormData.append(image, withName: "secondImage", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: headers, interceptor: JwtRequestInterceptor(jwtStore: AppDelegate.container.resolve(JwtStore.self)!))
        .validate().responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(AddPostModel.self, from: data)
                let firstImageUrl = decodeResponse?.firstUploadImageUrl ?? ""
                let secondImageUrl = decodeResponse?.secondUploadImageUrl ?? ""

                headers = ["Content-Type": "application/json"]
                url = APIConstants.createPostURL
                let params = [
                    "title" : title,
                    "content" : content,
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
                           interceptor: JwtRequestInterceptor(jwtStore: AppDelegate.container.resolve(JwtStore.self)!))
                .validate()
                .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
                    switch response.result {
                    case .success:
                        LoadingIndicator.hideLoading()
                        self?.coordinator.navigate(to: .popAddpostIsRequired)
                    case .failure(let error):
                        print("post error = \(String(describing: error.localizedDescription))")
                    }
                }
            case .failure(let error):
                print("upload error \(String(describing: error.localizedDescription))")
            }
        }
    }
    
    func pushAddImageVC(title: String, content: String?) {
        self.coordinator.navigate(to: .addImageIsRequired(title: title, content: content))
    }
}
