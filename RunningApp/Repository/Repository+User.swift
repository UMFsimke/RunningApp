import RxSwift

extension Repository {
    
    func refreshUser() -> Observable<Bool> {
        return Network.request(.refreshProfile)
            .mapToType(User.self)
            .do(onNext: { [weak self] in self?.user.value = $0 })
            .map{ _ in true }
    }
}
