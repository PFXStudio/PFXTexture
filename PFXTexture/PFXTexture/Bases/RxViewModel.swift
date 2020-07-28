import Foundation
import RxSwift

protocol RxViewModelProtocol {
    associatedtype Input
    associatedtype Output
    associatedtype Dependency

    var input: Input! { get }
    var output: Output! { get }
    func deinitialize()
//    var dependency: Dependency! { get }
}

class RxViewModel: NSObject {
    var disposeBag = DisposeBag()
    func deinitialize() {
        NotificationCenter.default.removeObserver(self)
        self.disposeBag = DisposeBag()
    }
    func initialize() {
        self.disposeBag = DisposeBag()
    }
}
