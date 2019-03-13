import UIKit

extension UIApplication {
    static var topViewController: UIViewController? {
        var topVC = UIApplication.shared.keyWindow?.rootViewController
    
        while(topVC?.presentedViewController != nil) {
            topVC = topVC!.presentedViewController
        }
    
        if let navController = topVC as? UINavigationController {
            topVC = navController.visibleViewController
        }
    
        return topVC
    }
}
