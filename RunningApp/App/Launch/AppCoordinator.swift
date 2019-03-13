import Foundation
import RxSwift

final class AppCoordinator: Coordinator, Parent {
    
    fileprivate(set) var children = [Coordinator]()
    fileprivate let db = DisposeBag()
    fileprivate let eventsSubject = BehaviorSubject<Event>(value: .fetchingSession)
    
    func start() {
        let launchController = R.storyboard.launchScreen.launchScreen()!
        Action.SwitchRootViewController(targetViewController: launchController, animated: false).perform()
        startApplication()
    }
    
}

fileprivate extension AppCoordinator {
    
    func startApplication() {
        
    }
}

//MARK: Coordinated

extension AppCoordinator {
    enum Event {
        case fetchingSession
        case fetchingSessionComplete
    }
    
    var events: Observable<Event> { return eventsSubject }
}
