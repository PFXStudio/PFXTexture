import Foundation
import UIKit
import RxSwift

protocol DeinitializableRxViewController {
    func deinitialize()
}

class RxViewController<T>: UIViewController, DeinitializableRxViewController {
    typealias ViewModel = T
    var viewModel: ViewModel!
    let hardImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var disposeBag = DisposeBag()
    
    func deinitialize() {
        self.disposeBag = DisposeBag()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if (self.parent == nil) {
            deinitialize()
        }
    }
}

class RxPageViewController<T>: UIPageViewController, DeinitializableRxViewController {
    typealias ViewModel = T
    var viewModel: ViewModel!
    let hardImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var disposeBag = DisposeBag()
    func deinitialize() {
        self.disposeBag = DisposeBag()
    }
}

class RxTableViewController<T>: UITableViewController, DeinitializableRxViewController {
    typealias ViewModel = T
    var viewModel: ViewModel!
    let hardImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var disposeBag = DisposeBag()
    func deinitialize() {
        self.disposeBag = DisposeBag()
    }
}

class RxNavigationController<T>: UINavigationController, DeinitializableRxViewController {
    typealias ViewModel = T
    var viewModel: ViewModel!
    let hardImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var disposeBag = DisposeBag()
    func deinitialize() {
        self.disposeBag = DisposeBag()
    }
}

class RxCollectionViewController<T>: UICollectionViewController, DeinitializableRxViewController {
    typealias ViewModel = T
    var viewModel: ViewModel!
    let hardImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var disposeBag = DisposeBag()
    func deinitialize() {
        self.disposeBag = DisposeBag()
    }
}
