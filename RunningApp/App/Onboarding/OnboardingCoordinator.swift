import Foundation
import RxSwift
import RxCocoa

final class OnboardingCoordinator: Coordinator, Parent {
    
    var children = [Coordinator]()
    
    fileprivate let db = DisposeBag()
    fileprivate let eventsSubject = PublishSubject<Event>()
    
    fileprivate lazy var onboardingViewController: OnboardingViewController = {
        return R.storyboard.onboarding.onboardingViewController()!
    }()
    
    func start() {
        // Clean the navigation delegate upon finishing
        self.eventsSubject
            .subscribe()
            .disposed(by: db)
        
        showOnboardingViewController()
    }
    
}

//MARK: - Coordinated

extension OnboardingCoordinator: Coordinated {
    enum Event {
        case signedUp
        case loggedIn
    }
    
    var events: Observable<Event> { return eventsSubject }
}

//MARK: - Presentation

fileprivate extension OnboardingCoordinator {
    
    func showOnboardingViewController() {
        createBindings(with: onboardingViewController)
        Action.SwitchRootViewController(targetViewController: onboardingViewController, animated: true).perform()
    }
    
    func showLoginViewController() {
        let loginVC = LoginViewController()
        createBindings(with: loginVC)
        push(loginVC)
    }
    
    func showSignupViewController() {
        /*let signupVC = SignupViewController()
        createBindings(with: signupVC)
        push(signupVC)*/
    }
    
    func showResetPasswordViewController() {
        
    }
}

//MARK: - Bindings

fileprivate extension OnboardingCoordinator {
    
    func createBindings(with onboardingViewController: OnboardingViewController) {
        onboardingViewController.events
            .subscribe(onNext: { (event) in
                switch event {
                case .login: self.showLoginViewController()
                case .signUp: self.showSignupViewController()
                }
            })
            .disposed(by: db)
    }
    
    func createBindings(with loginViewController: LoginViewController) {
        loginViewController.events
            .subscribe(onNext: { event in
                switch event {
                case .finished:
                    self.eventsSubject.onNext(.loggedIn)
                    
                case .requestedPasswordReset:
                    self.showResetPasswordViewController()
                }
            })
            .disposed(by: db)
    }
    
}
