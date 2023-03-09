import UIKit
import Alamofire

final class AddPostViewModel: BaseViewModel {
    func createPost(title: String, content: String, firstImage: UIImage, secondImage: UIImage,
                    firstVotingOption: String, secondVotingOtion: String) {
        var url = APIConstants.imageUploadURL
        var headers: HTTPHeaders = ["Content-Type" : "multipart/form-data"]
//        var params = [
//            "title" : title,
//            "content" : content,
//            "firstVotingOption" : firstVotingOption,
//            "secondVotingOption" : secondVotingOtion
//        ] as Dictionary
        
        AF.upload(multipartFormData: { multipartFormData in
//            for (key, value) in params {
//                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
            if let image = firstImage.pngData() {
                multipartFormData.append(image, withName: "file", fileName: "\(image).png", mimeType: "image/png")
            }
            if let image = secondImage.pngData() {
                multipartFormData.append(image, withName: "file", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: headers, interceptor: JwtRequestInterceptor())
        .validate().responseData(emptyResponseCodes: [200, 201, 204]) { response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(AddPostModel.self, from: data)
                let firstImageUrl = decodeResponse?.firstUploadImageUrl ?? ""
                let secondImageUrl = decodeResponse?.secondUploadImageUrl ?? ""

                headers = ["Content-Type": "application/json"]
                url = APIConstants.createPostURL
                var params = [
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
                           interceptor: JwtRequestInterceptor())
                .validate()
                .responseData(emptyResponseCodes: [200, 201, 204]) { [weak self] response in
                    switch response.result {
                    case .success:
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
}
