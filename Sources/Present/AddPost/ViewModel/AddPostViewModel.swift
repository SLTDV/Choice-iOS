import UIKit
import Alamofire

class AddPostViewModel: BaseViewModel {
    func createPost(title: String, content: String, imageData: UIImage, firstVotingOption: String, secondVotingOtion: String) {
        var url = APIConstants.imageUploadURL
        
        let headers: HTTPHeaders = ["Content-Type" : "multipart/form-data"]
        let params = [
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
        }, to: url, method: .post, headers: headers).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("success = \(data)")
            case .failure(let error):
                print("error \(error.localizedDescription)")
            }
        }
        
        url = APIConstants.createPostURL
        AF.request(url,
                   method: .post,
                   parameters: params,
                   encoding: URLEncoding.queryString,
                   headers: headers)
        .responseData { [weak self] response in
            switch response.result {
            case .success:
                print(response.response?.statusCode)
                self?.coordinator.navigate(to: .popAddpostIsRequired)
                
            case .failure(let error):
                print("error = \(error.errorDescription)")
            }
        }
        
    }
}
