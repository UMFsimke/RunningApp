extension AlertAction {
    
    static func cancel(title: String = R.string.localizedStrings.cancel(), action: Op? = nil) -> AlertAction {
        return AlertAction(title: title, action: action)
    }
    
    static func `default`(title: String = R.string.localizedStrings.ok(), action: Op? = nil) -> AlertAction {
        return AlertAction(title: title, action: action)
    }
    
}
