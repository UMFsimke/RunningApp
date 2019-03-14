import Foundation
import SwiftyJSON
import RxSwift

extension Observable {
    
    /// Get given JSONified data, pass back objects
    func mapToType<T: JSONDecodable>(_ classType: T.Type) -> Observable<T> {
        return self.map { json in
            guard let json = json as? JSON else {
                throw JSONDecodeError.couldNotParseJSON(type: classType)
            }
            
            return try self.value(from: json)
        }
    }
    
    /// Get given JSONified data, pass back objects as an array
    func mapToArrayWithElementOfType<T: JSONDecodable>(_ classType: T.Type) -> Observable<[T]> {
        return self.map { json in
            guard
                let json = json as? JSON,
                let root = json.dictionary,
                let array = root["data"]?.array
                else {
                    throw JSONDecodeError.couldNotParseJSON(type: classType)
            }
            
            return try array.map { try self.value(from: $0) }
        }
    }
    
}

// MARK: - Transformer

fileprivate extension Observable {
    
    func value<T: JSONDecodable>(from json: JSON) throws -> T {
        do {
            return try T.from(json)
        } catch {
            if let error = error as? JSONDecodeError {
                print(error.description)
                throw HTTPError.unknown(description: "Could not get \(error.type).")
            } else {
                throw error
            }
        }
    }
    
}
