import Foundation
import Alamofire

enum RunningAppAPI {
    
    //MARK: Auth
    case login(email: String, password: String)
    case signup(email: String, password: String, firstName: String, lastName: String)
    case refreshProfile
    
}

// MARK: - Method

extension RunningAppAPI {
    
    var method: HTTPMethod {
        switch self {
            
        case .login,
             .signup:
            return .post
            
        case .refreshProfile:
            return .get
        }
    }
    
}

// MARK: - Path

extension RunningAppAPI {
    
    var path: String {
        switch self {
            
        case .login:
            return "sign_in"
            
        case .signup:
            return "sign_up"
            
        case .refreshProfile:
            return "profile"
        }
    }
    
}

// MARK: - Parameters

extension RunningAppAPI {
    
    var parameters: Parameters {
        switch self {
            
        case .login(let email, let password):
            return [
                "email" : email,
                "password" : password
            ]
            
        case .signup(let email, let password, let firstName, let lastName):
            return [
                "email" : email,
                "password" : password,
                "firstName" : firstName,
                "lastName" : lastName
            ]
            
        case .refreshProfile:
            return [:]
        }
    }
    
}

// MARK: - Headers

extension RunningAppAPI {
    
    struct Header {
        static let emailKey = "Email"
        static let tokenKey = "Token"
    }
    
}

extension RunningAppAPI {
    
    static var defaultHeaders: HTTPHeaders {
        return HTTPHeaders([
            Header.emailKey : UserSession.email ?? "",
            Header.tokenKey : UserSession.token ?? ""
        ])
    }
    
    var headers: HTTPHeaders {
        return RunningAppAPI.defaultHeaders
    }
    
}
