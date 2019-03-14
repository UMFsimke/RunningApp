import RxSwift

extension Repository {
    
    var hasActiveSession: Bool {
        return false
    }
    
    func refreshSession() -> Observable<Bool> {
        return refreshUser()
    }
    
    func authorize(email: String, password: String) -> Observable<User> {
        return Network.request(.login(email: email, password: password))
            .mapToType(User.self)
            .do(onNext: { [weak self] in self?.user = $0 })
    }
}
