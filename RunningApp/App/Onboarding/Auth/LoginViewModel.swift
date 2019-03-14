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
            .subscribe(onNext: { [weak self] in self?.login(for: $0) })
            .disposed(by: db)
    }
    
    func login(email: String, password: String) {
        state.value = State(email: email, password: password)
    }
    
}

//MARK: - Auth logic

fileprivate extension LoginViewModel {
    
    func login(for state: State) {
        Observable<State>.create{ (downstream) in
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
        .subscribe(onNext: { [weak self] _ in self?.eventsSubject.onNext(.loggedIn) },
                   onError: { [weak self] in self?.handleError($0) })
        .disposed(by: db)
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
        case loggedIn
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
            let httpError: HTTPError? = error as? HTTPError
            if httpError != nil {
                message = httpError!.description
            } else {
                message = ""
            }
        }
        
        eventsSubject.onNext(.error(message: message))
    }
}
