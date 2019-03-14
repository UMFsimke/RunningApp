import RxSwift

final class Repository : Singleton {
    
    static var shared: Repository = Repository()
    internal var user = Variable<User?>(nil)
    
    private init() { }
}



