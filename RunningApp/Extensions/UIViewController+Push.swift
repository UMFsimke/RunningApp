import UIKit

extension UIViewController {
    
    func push(_ vc: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(vc, animated: animated)
    }
}
