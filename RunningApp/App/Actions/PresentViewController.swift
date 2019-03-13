import Foundation
import UIKit

extension Action {
    
    struct PresentViewController {
        
        fileprivate let presentingViewController: UIViewController?
        fileprivate let presentedViewController: UIViewController
        fileprivate let completion: (() -> Void)?
        
        init(presentingViewController: UIViewController? = UIApplication.topViewController, presentedViewController: UIViewController, completion: (() -> Void)? = nil) {
            self.presentingViewController = presentingViewController ?? UIApplication.topViewController
            self.presentedViewController = presentedViewController
            self.completion = completion
        }
        
    }
    
}

// MARK: - Actionable

extension Action.PresentViewController: Actionable {
    
    func perform() {
        guard let presentingViewController = presentingViewController else {
            assertionFailure("Could not present view controller '\(presentedViewController.nameOfClass)'. No presenting view controller could be found")
            return
        }
        
        presentingViewController.present(presentedViewController, animated: true, completion: completion)
    }
    
}
