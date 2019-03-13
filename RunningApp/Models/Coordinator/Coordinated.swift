import RxSwift

protocol Coordinated: class {
    associatedtype Event
    var events: Observable<Event> { get }
}
