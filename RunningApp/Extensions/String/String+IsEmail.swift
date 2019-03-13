import Foundation

extension String {
    
    var isEmail: Bool {
        let pattern = "[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}" +
            "\\@" +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
            "(" +
            "\\." +
            "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+"

        return !self.isEmpty && self.matchesPattern(pattern)
    }
}
