import Foundation
import SAMKeychain

private let keychainService = "RunningAppService"

private enum Attribute: String {
    case id = "currentUserID"
    case email = "currentUserEmail"
    case token = "currentUserAuthToken"
    
    static var allValues = [ Attribute.id, .email, .token ]
}

struct UserSession {
    
    static var exists: Bool {
        return (email != nil && token != nil)
    }
    
    static var doesNotExist: Bool {
        return !exists
    }
    
    static var id: String? {
        return valueForCredentail(.id)
    }
    
    static var email: String? {
        return valueForCredentail(.email)
    }
    
    static var token: String? {
        return valueForCredentail(.token)
    }
    
}

// MARK: - Session Maangement

extension UserSession {
    
    static func clear() {
        Attribute.allValues
            .forEach { removeCredential($0) }
    }
    
    static func set(_ user: User?) {
        guard let user = user else { clear(); return }
        [(user.id, Attribute.id),
         (user.email, Attribute.email),
         (user.token, Attribute.token)]
            .forEach { storeValue($0.0, forCredential: $0.1) }
    }
    
}

// MARK: - Storage

fileprivate extension UserSession {
    
    static func valueForCredentail(_ credential: Attribute) -> String? {
        return SAMKeychain.password(forService: keychainService, account: credential.rawValue)
    }
    
    static func storeValue(_ value: String?, forCredential credential: Attribute) {
        guard let value = value else {
            removeCredential(credential)
            return
        }
        
        SAMKeychain.setPassword(
            value,
            forService: keychainService,
            account: credential.rawValue
        )
    }
    
    static func removeCredential(_ credential: Attribute) {
        SAMKeychain.deletePassword(forService: keychainService, account: credential.rawValue)
    }
    
}
