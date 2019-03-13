import Foundation
import RxSwift

final class AppCoordinator: Coordinator, Parent {
    
    fileprivate(set) var children = [Coordinator]()
    fileprivate let db = DisposeBag()
    fileprivate let eventsSubject = BehaviorSubject<Event>(value: .fetchingSession)
    fileprivate let repository = Repository.shared
    
    func start() {
        let launchController = R.storyboard.launchScreen.launchScreen()!
        Action.SwitchRootViewController(targetViewController: launchController, animated: false).perform()
        startApplication()
    }
    
}

//MARK: -Logic

fileprivate extension AppCoordinator {
    
    func startApplication() {
        Observable.combineLatest(
            getMinimalSplashScreenDurationTimer(),
            refreshIfSessionExistsObservable()) { $1 }
            .observeOn(Schedulers.shared.concurrentMain)
            .subscribe(onNext: { [weak self] sessionExists in
                guard let `self` = self else { return }
            
                self.eventsSubject.onNext(.fetchingSessionComplete)
                if sessionExists {
                    self.startTabBarCoordinator()
                    return
                }
                
                self.startOnboardingCoordinator()
            })
            .disposed(by: db)
    }
    
    private func getMinimalSplashScreenDurationTimer() -> Observable<Int> {
        return Observable<Int>.timer(Constant.SplashScreen.MinimalDuration,
                                     scheduler: Schedulers.shared.concurrentBackground)
            .take(1)
            .observeOn(Schedulers.shared.concurrentMain)
    }
    
    private func refreshIfSessionExistsObservable() -> Observable<Bool> {
        if repository.hasActiveSession {
            return repository.refreshSession()
                .catchErrorJustReturn(false)
        }
        
        return Observable.just(false)
    }
}

//MARK: - Presentations

fileprivate extension AppCoordinator {
    
    func startTabBarCoordinator() {
        print("a")
    }
    
    func startOnboardingCoordinator() {
        let onboardingCoordinator = OnboardingCoordinator()
        children.push(onboardingCoordinator)
        createBindings(with: onboardingCoordinator)
        onboardingCoordinator.start()
    }
}

//MARK: - Bindings

fileprivate extension AppCoordinator {
    
    func createBindings(with onboardingCoordinator: OnboardingCoordinator) {
        onboardingCoordinator.events
            .subscribe(onNext: { [weak self] event in
                switch event {
                case .loggedIn:
                    self?.startTabBarCoordinator()
                case .signedUp:
                    self?.startTabBarCoordinator()
                }})
            .disposed(by: db)
    }
    
}
//MARK: -Coordinated

extension AppCoordinator {
    enum Event {
        case fetchingSession
        case fetchingSessionComplete
    }
    
    var events: Observable<Event> { return eventsSubject }
}
