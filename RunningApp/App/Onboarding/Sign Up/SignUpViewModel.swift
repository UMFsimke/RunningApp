import RxSwift
import Rswift

class SignUpViewModel {
    
    fileprivate let db = DisposeBag()
    fileprivate let state = Variable<State>(.empty)
    fileprivate let eventsSubject = PublishSubject<Event>()
    fileprivate let repository = Repository.shared
    
    func start() {
        state.asObservable()
            .skip(1)
            .subscribe(onNext: { [weak self] in self?.signUp(for: $0) })
            .disposed(by: db)
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String) {
        state.value = State(email: email,
                            password: password,
                            firstName: firstName,
                            lastName: lastName)
    }
    
}

//MARK: - Auth logic

fileprivate extension SignUpViewModel {
    
    func signUp(for state: State) {
        Observable<State>.create{ (downstream) in
            if !state.email.isEmail {
                downstream.onError(AuthError.invalidEmail)
                return Disposables.create()
            }
            
            if state.password.count < Constant.Auth.MinPasswordLength {
                downstream.onError(AuthError.invalidPassword)
                return Disposables.create()
            }
            
            if state.firstName.isEmpty {
                downstream.onError(AuthError.invalidFirstName)
                return Disposables.create()
            }
            
            if state.lastName.isEmpty {
                downstream.onError(AuthError.invalidLastName)
                return Disposables.create()
            }
            
            downstream.onNext(state)
            downstream.onCompleted()
            return Disposables.create()
            }
            .flatMap{ [weak self] (validatedState) -> Observable<User> in
                guard let `self` = self else { return .empty() }
                return self.repository.signUp(email: validatedState.email,
                                              password: validatedState.password,
                                              fistName: validatedState.firstName,
                                              lastName: validatedState.lastName)
            }
            .subscribe(onNext: { [weak self] _ in self?.eventsSubject.onNext(.signedUp) },
                       onError: { [weak self] in self?.handleError($0) })
            .disposed(by: db)
    }
}

//MARK: - State

fileprivate extension SignUpViewModel {
    
    struct State {
        let email: String
        let password: String
        let firstName: String
        let lastName: String
        
        static let empty = State(email: "", password: "", firstName: "", lastName: "")
    }
}

//MARK: - Coordinated

extension SignUpViewModel: Coordinated {
    
    enum Event {
        case signedUp
        case error(message: String)
    }
    
    var events: Observable<Event> { return eventsSubject }
}

//MARK: - Error handling

fileprivate extension SignUpViewModel {
    
    func handleError(_ error: Error) {
        let loginError: AuthError? = error as? AuthError
        var message: String = ""
        if loginError != nil {
            switch loginError! {
            case .invalidEmail:
                message = R.string.localizedStrings.invalidEmailErrorMessage()
            case .invalidPassword:
                message = R.string.localizedStrings.invalidPasswordErrorMessage()
            case .invalidFirstName:
                message = R.string.localizedStrings.invalidFirstNameErrorMessage()
            case .invalidLastName:
                message = R.string.localizedStrings.invalidLastNameErrorMessage()
            }
        } else {
            let httpError: HTTPError? = error as? HTTPError
            if httpError != nil {
                message = httpError!.description
            }
        }
        
        eventsSubject.onNext(.error(message: message))
    }
}
