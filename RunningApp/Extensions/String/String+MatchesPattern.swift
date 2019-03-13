import Foundation

//MARK: - Regex Validation

extension String {
    
    func matchesPattern(_ pattern: String) -> Bool {
        guard let _ = range(of: pattern, options: .regularExpression) else { return false }
        return true
    }
    
}
