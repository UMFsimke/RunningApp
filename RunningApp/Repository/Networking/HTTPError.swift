import Foundation
import Alamofire
import Rswift

enum HTTPError: DescriptiveDebugError {
    
    case badRequest(description: String?)
    case unauthorized(description: String?)
    case notFound(description: String?)
    case serverError(description: String?)
    case unknown(description: String?)
    case duplicateAccount(description: String?)
    
    init(statusCode: Int? = nil, description: String? = nil) {
        guard let statusCode = statusCode else {
            self = .unknown(description: description)
            return
        }
        
        switch statusCode {
        case 400: self = .badRequest(description: description)
        case 401: self = .unauthorized(description: description)
        case 404: self = .notFound(description: description)
        case 409: self = .duplicateAccount(description: description)
        case 500: self = .serverError(description: description)
        default: self = .unknown(description: description)
        }
    }
    
    init(statusCode: Int?, json: JSON) {
        let description = json["message"].string
        
        self.init(statusCode: statusCode, description: description)
    }
    
}

// MARK: - Convenience accessors

extension HTTPError {
    
    static var anonymousError: HTTPError {
        return HTTPError.unknown(description: R.string.localizedStrings.defaultErrorDescription())
    }
    
    var statusCode: Int? {
        switch self {
        case .badRequest: return 400
        case .unauthorized: return 401
        case .notFound: return 404
        case .duplicateAccount: return 409
        case .serverError: return 500
        case .unknown: return nil
        }
    }
    
}

// MARK: - CustomStringConvertible

extension HTTPError: CustomStringConvertible, CustomDebugStringConvertible {
    
    var description: String {
        let desc: String?
        switch self {
        case .badRequest(let description):
            desc = description
        case .unauthorized(let description):
            desc = description
        case .notFound(let description):
            desc = description
        case .serverError(let description):
            desc = description
        case .duplicateAccount(let description):
            desc = description
        case .unknown(let description):
            desc = description
            
        }
        
        return desc ?? R.string.localizedStrings.defaultErrorDescription()
    }
    
    var debugDescription: String {
        guard let statusCode = statusCode else { return description }
        return [String(statusCode), description].joined(separator: " ")
    }
    
}

// MARK: - Equatable

extension HTTPError: Equatable {}
func ==(lhs: HTTPError, rhs: HTTPError) -> Bool {
    switch (lhs, rhs) {
        
    case
    (.badRequest, .badRequest),
    (.unauthorized, .unauthorized),
    (.notFound, .notFound),
    (.serverError, .serverError),
    (.duplicateAccount, .duplicateAccount),
    (.unknown, .unknown):
        return true
        
    default:
        return false
        
    }
}
