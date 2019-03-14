import RxSwift

extension Repository {
    
    var hasActiveSession: Bool {
        return false
    }
    
    func refreshSession() -> Observable<Bool> {
        return refreshUser()
    }
}
