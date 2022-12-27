import UIKit
import Alamofire

final class AddPostViewModel: BaseViewModel {
    func createPost(title: String, content: String, imageData: UIImage, firstVotingOption: String, secondVotingOtion: String) {
        var url = APIConstants.imageUploadURL
        var headers: HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        var params = [
            "title" : title,
            "content" : content,
            "firstVotingOption" : firstVotingOption,
            "secondVotingOption" : secondVotingOtion
        ] as Dictionary
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if let image = imageData.pngData() {
                multipartFormData.append(image, withName: "file", fileName: "\(image).png", mimeType: "image/png")
            }
        }, to: url, method: .post, headers: headers, interceptor: JwtRequestInterceptor())
                .validate(statusCode: 200..<300).responseData { response in
            switch response.result {
            case .success(let data):
                let decodeResponse = try? JSONDecoder().decode(AddPostModel.self, from: data)
                let imagUrl = decodeResponse?.imageUrl ?? ""
                
                headers = ["Content-Type": "application/json"]
                url = APIConstants.createPostURL
                params = [
                    "title" : title,
                    "content" : content,
                    "firstVotingOption" : firstVotingOption,
                    "secondVotingOption" : secondVotingOtion,
                    "thumbnail" : imagUrl
                ]
                
                AF.request(url,
                           method: .post,
                           parameters: params,
                           encoding: JSONEncoding.default,
                           headers: headers,
                           interceptor: JwtRequestInterceptor())
                .validate(statusCode: 200..<300)
                .responseData { [weak self] response in
                    switch response.result {
                    case .success:
                        self?.coordinator.navigate(to: .popAddpostIsRequired)
                    case .failure(let error):
                        print(response.response?.statusCode)
                        print("post error = \(String(describing: error.localizedDescription))")
                    }
                }
            case .failure(let error):
                print("upload error \(String(describing: error.localizedDescription))")
            }
        }
    }
}
