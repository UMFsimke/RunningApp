import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {
    
    fileprivate let eventsSubject = PublishSubject<Event>()
    fileprivate let db = DisposeBag()
    fileprivate let model = LoginViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
}

//MARK: - Coordinated

extension LoginViewController: Coordinated {
    enum Event {
        case finished
        case requestedPasswordReset
    }
    
    var events: Observable<Event> { return eventsSubject }
}

//MARK: - ViewLifecycle

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
        bindToLoginButtonClick()
        
        model.start()
    }
    
}

//MARK: Bindings

fileprivate extension LoginViewController {
    
    func bindToViewModel() {
        model.events
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                
                switch $0 {
                case .loggedIn:
                   self.eventsSubject.onNext(.finished)
                case .error(let message):
                    self.presentAlert(withMessage: message)
                }
            })
            .disposed(by: db)
    }
    
    func bindToLoginButtonClick() {
        loginButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.model.login(email: self.emailTextField.safeText,
                                 password: self.passwordTextField.safeText)
            })
            .disposed(by: db)
    }
}

//MARK: - Alerts

fileprivate extension LoginViewController {
    
    func presentAlert(withMessage message: String) {
        Action.PresentAlert(title: R.string.localizedStrings.errorTitle(), message: message, viewController: self).perform()
    }
    
}
