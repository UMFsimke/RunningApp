import Foundation

extension Optional {
    
    func apply(_ f: (Wrapped) throws -> ()) rethrows {
        switch self {
        case .some(let value):
            try f(value)
        case .none:
            break
        }
    }
    
}
