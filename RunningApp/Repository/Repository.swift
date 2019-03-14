import RxSwift

final class Repository : Singleton {
    
    static var shared: Repository = Repository()
    internal var user: User?
    
    private init() { }
}



