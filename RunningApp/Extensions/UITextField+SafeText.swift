import Foundation
import UIKit

extension UITextField {
    
    var safeText: String {
        return self.text ?? ""
    }
}
