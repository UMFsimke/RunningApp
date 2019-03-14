import Foundation
import RxSwift

extension Observable {
    
    func doOnNextOrError(_ closure: @escaping Op) -> Observable<Element> {
        return self.do(
            onNext: { _ in closure() },
            onError: { _ in closure() }
        )
    }
    
}
