import Foundation
import UIKit

struct AlertAction {
    let title: String
    let action: (UIAlertAction) -> Void
    
    init(title: String = "OK", action: Op? = nil) {
        self.title = title
        self.action = { (a) in
            action?()
        }
    }
    
}
