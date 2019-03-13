import RxSwift

extension Repository {
    
    var hasActiveSession: Bool {
        return false
    }
    
    func refreshSession() -> Observable<Bool> {
        return refreshUser()
    }
    
    func authorize(email: String, password: String) -> Observable<User> {
        return Observable.just(User())
    }
}
