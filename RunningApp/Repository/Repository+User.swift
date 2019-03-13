import RxSwift

extension Repository {
    
    func refreshUser() -> Observable<Bool> {
        return Observable.just(true)
    }
}
