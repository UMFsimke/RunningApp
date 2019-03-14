enum JSONDecodeError: DescriptiveError {
    case couldNotParseJSON(type: Any.Type)
    case missingValue(forKey: String, type: Any.Type)
    case unexpectedValue(value: String, key: String, type: Any.Type)
    case valueNotFound(forKey: String, file: String, line: Int, function: String)
    
    var description: String {
        switch self {
        case .couldNotParseJSON(let type):
            return "\(type): Could not parse JSON"
            
        case .missingValue(let key, let type):
            return "\(type): JSON missing value for key '\(key)'"
            
        case .unexpectedValue(let value, let key, let type):
            return "\(type): Found unexpected value '\(value)' for key '\(key)' "
            
        case let .valueNotFound(key, file, line, function):
            return "JSON Decode Error\nMissing Value for \(key) in\n\(file): \(line) \(function)"
        }
    }
    
    var type: Any.Type {
        switch self {
        case .couldNotParseJSON(let type): return type
        case .missingValue(_, let type): return type
        case .unexpectedValue(_, _, let type): return type
        case .valueNotFound: return Any.self
        }
    }
}
