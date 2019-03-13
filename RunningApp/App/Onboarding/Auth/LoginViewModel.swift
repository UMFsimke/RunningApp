import RxSwift
import Rswift

class LoginViewModel {
    
    fileprivate let db = DisposeBag()
    fileprivate let state = Variable<State>(.empty)
    fileprivate let eventsSubject = PublishSubject<Event>()
    fileprivate let repository = Repository.shared
    
    func start() {
        state.asObservable()
            .skip(1)
            .flatMapLatest{  [weak self] (state) -> Observable<User> in
                guard let `self` = self else { return .empty() }
                return self.login(for: state)
            }
            .subscribe(onNext: { [weak self] (user) in
                    self?.eventsSubject.onNext(.loggedIn(user: user))
                }, onError: { [weak self] in
                    self?.handleError($0)
                })
            .disposed(by: db)
    }
    
    func login(email: String, password: String) {
        state.value = State(email: email, password: password)
    }
    
}

//MARK: - Auth logic

fileprivate extension LoginViewModel {
    
    func login(for state: State) -> Observable<User> {
        return Observable<State>.create{ (downstream) in
                if !state.email.isEmail {
                    downstream.onError(LoginError.invalidEmail)
                    return Disposables.create()
                }
            
                if state.password.count < Constant.Auth.MinPasswordLength {
                    downstream.onError(LoginError.invalidPassword)
                    return Disposables.create()
                }
            
                downstream.onNext(state)
                downstream.onCompleted()
                return Disposables.create()
            }
            .flatMap{ [weak self] (validatedState) -> Observable<User> in
                guard let `self` = self else { return .empty() }
                return self.repository.authorize(email: validatedState.email,
                                                 password: validatedState.password)
            }
    }
}

//MARK: - State

fileprivate extension LoginViewModel {
    
    struct State {
        let email: String
        let password: String
        
        static let empty = State(email: "", password: "")
    }
}

//MARK: - Coordinated

extension LoginViewModel: Coordinated {
    
    enum Event {
        case loggedIn(user: User)
        case error(message: String)
    }
    
    var events: Observable<Event> { return eventsSubject }
}

//MARK: - Error handling

fileprivate extension LoginViewModel {
    
    func handleError(_ error: Error) {
        let loginError: LoginError? = error as? LoginError
        let message: String
        if loginError != nil {
            switch loginError! {
            case .invalidEmail:
                message = R.string.localizedStrings.invalidEmailErrorMessage()
            case .invalidPassword:
                message = R.string.localizedStrings.invalidPasswordErrorMessage()
            }
        } else {
            message = ""
        }
        
        eventsSubject.onNext(.error(message: message))
    }
}
