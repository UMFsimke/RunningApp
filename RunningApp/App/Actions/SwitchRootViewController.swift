import Foundation
import UIKit

extension Action {
    
    struct SwitchRootViewController {
        
        enum Animation {
            case fade, slide
        }
        
        fileprivate let targetVC: UIViewController
        fileprivate let animated: Bool
        fileprivate let animation: Animation
        fileprivate let completion: Op?
        
        init(targetViewController: UIViewController, animated: Bool = true, animation: Animation = .fade, completion: Op? = nil) {
            targetVC = targetViewController
            self.animated = animated
            self.animation = animation
            self.completion = completion
        }
        
    }
    
}

// MARK: - Actionable

extension Action.SwitchRootViewController: Actionable {
    
    func perform() {
        guard animated,
            let snapshot = UIApplication.currentWindow.snapshotView(afterScreenUpdates: true)
            else {
                UIApplication.currentWindow.rootViewController = targetVC
                return
        }
        
        targetVC.view.addSubview(snapshot)
        UIApplication.currentWindow.rootViewController = targetVC
        
        let completion = { (completed: Bool) in
            snapshot.removeFromSuperview()
            self.completion?()
        }
        
        switch animation {
            
        case .fade:
            UIView.animate(
                withDuration: Constant.RootViewControllerTransition.DurationFade,
                animations: { snapshot.alpha = 0 },
                completion: completion
            )
            
        case .slide:
            let screenHeight = UIScreen.main.bounds.height
            let translateTransform = CGAffineTransform(translationX: 0, y: screenHeight)
            
            UIView.animate(
                withDuration: Constant.RootViewControllerTransition.DurationSlide,
                delay: Constant.RootViewControllerTransition.Delay,
                usingSpringWithDamping: Constant.RootViewControllerTransition.SpringDampening,
                initialSpringVelocity: 0,
                options: [],
                animations: { () -> Void in
                    snapshot.transform = translateTransform
                },
                completion: completion
            )
            
        }
    }
    
}
