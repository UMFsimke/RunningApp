import RxSwift

extension Repository {
    
    func authorize(email: String, password: String) -> Observable<User> {
        return Network.request(.login(email: email, password: password))
            .mapToType(User.self)
            .do(onNext: { [weak self] in self?.user.value = $0 })
    }
    
    func signUp(email: String, password: String, fistName: String, lastName: String) -> Observable<User> {
        return Network.request(.signup(email: email,
                                       password: password,
                                       firstName: fistName,
                                       lastName: lastName))
            .mapToType(User.self)
            .do(onNext: { [weak self] in self?.user.value = $0 })
    }
}



