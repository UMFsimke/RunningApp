import Foundation
import RxSwift
import Alamofire

struct Network {
    
    static func request(_ endpoint: RunningAppAPI) -> Observable<JSON> {
        let fullPath = accessPoint(fromPath: endpoint.path)
        return request(method: endpoint.method,
                       path: fullPath,
                       parameters: endpoint.parameters,
                       headers: endpoint.headers)
    }
    
    static func request(
        method: HTTPMethod,
        path: String,
        parameters: Parameters = [:],
        headers: HTTPHeaders = [:]) -> Observable<JSON>
    {
        let request = Observable<JSON>.create { o in
            let request = AF
                .request(
                    path,
                    method: method,
                    parameters: parameters,
                    encoding: URLEncoding(destination: .methodDependent),
                    headers: headers,
                    interceptor: nil)
                .responseJSON { response in
                    log(response)
                    
                    do {
                        let json = try JSON.fromValidating(response)
                        o.onNext(json)
                        o.onCompleted()
                    }
                    catch { o.onError(error) }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return request
            .doOnNextOrError { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
    }
    
}


// MARK: - Constructors

fileprivate extension Network {
    
    static func accessPoint(fromPath path: String) -> String {
        return Configuration().apiHost + path
    }
    
}

//MARK: - Logging

fileprivate extension Network {
    
    static func log(_ dataResponse: DataResponse<Any>) {
        guard let request = dataResponse.request, let response = dataResponse.response else {
            debugPrint(dataResponse); return
        }
        
        print("\(response.statusCode): \(description(of: request))")
    }
    
    static func log(_ request: DataRequest) {
        request.request.apply { print(description(of: $0)) }
    }
    
    private static func description(of request: URLRequest) -> String {
        return "\(request.httpMethod ?? "") \(request.url?.description ?? "")"
    }
    
}

// MARK: - JSON Validation

fileprivate extension JSON {
    
    static func fromValidating(_ response: DataResponse<Any>) throws -> JSON {
        guard let httpResponse = response.response else {
            response.request.apply { debugPrint($0) }
            throw HTTPError.unknown(description: "Internal Error")
        }
        
        let data: Any
        switch response.result {
        case .success(let value): data = value
        case .failure(let error): data = error
        }
        
        let json = JSON(data)
        
        switch httpResponse.statusCode {
            
        case (200...299):
            return json
            
        default:
            response.request.apply { debugPrint($0) }
            throw HTTPError(statusCode: httpResponse.statusCode, json: json)
            
        }
    }
    
}
