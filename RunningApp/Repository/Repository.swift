import RxSwift

final class Repository : Singleton {
    
    static var shared: Repository = Repository()
    
    private init() { }
}



