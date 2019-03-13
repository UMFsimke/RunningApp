import RxSwift

struct Schedulers : Singleton {
    
    static var shared = Schedulers()
    
    let concurrentBackground : ConcurrentDispatchQueueScheduler
    let main: MainScheduler
    let concurrentMain: ConcurrentMainScheduler
    
    private init() {
        concurrentBackground = ConcurrentDispatchQueueScheduler(qos: .background)
        main = MainScheduler.instance
        concurrentMain = ConcurrentMainScheduler.instance
    }
}
