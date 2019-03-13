import UIKit

extension UIApplication {
    
    static var currentWindow: UIWindow {
        return shared.delegate!.window!!
    }
    
}
