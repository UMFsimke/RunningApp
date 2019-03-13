import RxSwift

extension Repository {
    
    var hasActiveSession: Bool {
        return true
    }
    
    func refreshSession() -> Observable<Bool> {
        return refreshUser()
    }
}
