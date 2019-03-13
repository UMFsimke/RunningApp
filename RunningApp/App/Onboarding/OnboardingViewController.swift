import UIKit
import RxSwift
import RxCocoa

final class OnboardingViewController: UIViewController {
    
    fileprivate let eventsSubject = PublishSubject<Event>()
    fileprivate let db = DisposeBag()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
}

//MARK: - Coordinated

extension OnboardingViewController: Coordinated {
    enum Event {
        case login
        case signUp
    }
    
    var events: Observable<Event> { return eventsSubject }
}

//MARK: - ViewLifecycle

extension OnboardingViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindToLoginButton()
        bindToSignUpButton()
    }
    
}

//MARK: - Bindings

fileprivate extension OnboardingViewController {
    
    func bindToLoginButton() {
        loginButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in self?.eventsSubject.onNext(.login) })
            .disposed(by: db)
    }
    
    func bindToSignUpButton() {
        signUpButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in self?.eventsSubject.onNext(.signUp) })
            .disposed(by: db)
    }
}
