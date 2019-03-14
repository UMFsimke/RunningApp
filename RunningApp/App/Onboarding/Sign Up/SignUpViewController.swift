import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
    
    fileprivate let eventsSubject = PublishSubject<Event>()
    fileprivate let db = DisposeBag()
    fileprivate let model = SignUpViewModel()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
}

//MARK: - Coordinated

extension SignUpViewController: Coordinated {
    enum Event {
        case finished
    }
    
    var events: Observable<Event> { return eventsSubject }
}

//MARK: - ViewLifecycle

extension SignUpViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToViewModel()
        bindToSignUpButtonClick()
        
        model.start()
    }
    
}

//MARK: Bindings

fileprivate extension SignUpViewController {
    
    func bindToViewModel() {
        model.events
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                
                switch $0 {
                case .signedUp:
                    self.eventsSubject.onNext(.finished)
                case .error(let message):
                    self.presentAlert(withMessage: message)
                }
            })
            .disposed(by: db)
    }
    
    func bindToSignUpButtonClick() {
        signUpButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.model.signUp(email: self.emailTextField.safeText,
                                  password: self.passwordTextField.safeText,
                                  firstName: self.firstNameTextField.safeText,
                                  lastName: self.lastNameTextField.safeText)
            })
            .disposed(by: db)
    }
}

//MARK: - Alerts

fileprivate extension SignUpViewController {
    
    func presentAlert(withMessage message: String) {
        Action.PresentAlert(title: R.string.localizedStrings.errorTitle(), message: message, viewController: self).perform()
    }
    
}
