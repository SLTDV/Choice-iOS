import Foundation
import Alamofire
import JwtStore

public protocol BaseRouter: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: RequestParams { get }
    var multipart: MultipartFormData { get }
    var header: HeaderType { get }
}

public extension BaseRouter {
    var baseURL: String {
        return "https://server.choice-time.com/"
    }

    // URLRequestConvertible 구현
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest = makeHeaderForRequest(to: urlRequest)
        urlRequest = try makeParameterForRequest(to: urlRequest, with: url)
        
        return urlRequest
    }
    
    private func makeHeaderForRequest(to request: URLRequest) -> URLRequest {
        let container = DIContainer.shared.resolve(JwtStore.self)!
        var request = request

        switch header {

        case .notHeader:
            request.setValue(HeaderContent.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            
        case .withToken:
            request.setValue(HeaderContent.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue("Bearer " + container.getToken(type: .accessToken), forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)

        case .multiPart:
            request.setValue(HTTPHeaderField.formDataType.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)

        case .multiPartWithToken:
            request.setValue(HTTPHeaderField.formDataType.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
            request.setValue(container.getToken(type: .accessToken), forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        }

        return request
    }
        
    private func makeParameterForRequest(to request: URLRequest, with url: URL) throws -> URLRequest {
        var request = request
        
        switch parameters {
        case .query(let query):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
        case .requestBody(let body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case .queryBody(let query, let body):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case .requestPlain:
            break
        }
        return request
    }
}

public enum RequestParams {
    case queryBody(_ query: [String : Any], _ body: [String : Any])
    case query(_ query: [String : Any])
    case requestBody(_ body: [String : Any])
    case requestPlain
}

public enum HeaderType {
    case withToken, multiPart, multiPartWithToken, notHeader
}
