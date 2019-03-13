import Foundation
import UIKit

extension Action {
    
    struct PresentAlert {
        
        fileprivate let alertController: UIViewController
        var viewController: UIViewController?
        
        init(
            title: String? = R.string.localizedStrings.errorTitle(),
            message: String? = nil,
            actions: [AlertAction] = [.default()],
            viewController: UIViewController? = nil)
        {
            self.viewController = viewController
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .actionSheet
            )
            actions
                .map{ UIAlertAction(title: $0.title, style: .default, handler: $0.action) }
                .forEach(alert.addAction)
            alertController = alert
        }
        
    }
    
}

// MARK: - Actionable

extension Action.PresentAlert: Actionable {
    
    func perform() {
        Action.PresentViewController(presentingViewController: viewController,
                                     presentedViewController: alertController)
            .perform()
    }
    
}
