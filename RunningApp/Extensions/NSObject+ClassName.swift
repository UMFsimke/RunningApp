import Foundation

extension NSObject {
    
    class var nameOfClass: String {
        return classNameFromClass(self)
    }
    
    var nameOfClass: String {
        return NSObject.classNameFromClass(type(of: self))
    }
    
    private class func classNameFromClass(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
}
