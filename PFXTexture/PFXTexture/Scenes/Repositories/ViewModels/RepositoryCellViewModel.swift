import Foundation
import RxSwift
import RxCocoa

class RepositoryCellViewModel: RxCellViewModel, RxViewModelProtocol {
    struct Input {
        var willDisplay: AnyObserver<Bool>
        var tapProfile: AnyObserver<Void>
    }
    struct Output {
        var loading: Observable<Bool>
        var error: Observable<String>
        var username: Observable<String>
        var profileUrl: Observable<URL>
        var desc: Observable<String>
        var status: Observable<String>
        var index: Observable<Int>
    }
    
    struct Dependency {
        var model: RepositoryModel!
    }
    var input: RepositoryCellViewModel.Input!
    var output: RepositoryCellViewModel.Output!
    var dependency: RepositoryCellViewModel.Dependency!
    private var willDisplaySubject = PublishSubject<Bool>()
    private var tapProfileSubject = PublishSubject<Void>()
    private var loadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<String>()
    private var usernameSubject = PublishSubject<String>()
    private var profileUrlSubject = PublishSubject<URL>()
    private var descSubject = PublishSubject<String>()
    private var statusSubject = PublishSubject<String>()
    private var indexSubject = PublishSubject<Int>()

    private var lastId: Int? = nil
    private var items: [RepositoryViewModel] = []

    init(reuseIdentifier: String, identifier: String, dependency: Dependency) {
        super.init(reuseIdentifier: reuseIdentifier, identifier: identifier)
        self.dependency = dependency
        self.initialize()
    }

    override func initialize() {
        super.initialize()
        // swiftlint:disable line_length
        self.input = RepositoryCellViewModel.Input(willDisplay: self.willDisplaySubject.asObserver(),
                                                   tapProfile: self.tapProfileSubject.asObserver()
        )
        self.output = RepositoryCellViewModel.Output(loading: self.loadingSubject.asObservable(),
                                           error: self.errorSubject.asObservable(),
                                           username: self.usernameSubject.asObservable(),
                                           profileUrl: self.profileUrlSubject.asObservable(),
                                           desc: self.descSubject.asObservable(),
                                           status: self.statusSubject.asObservable(),
                                           index: self.indexSubject.asObservable()
        )
        // swiftlint:enable line_length
        
        self.bindInputs()
    }
    
    func bindInputs() {
        self.willDisplaySubject
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                if let target = self.dependency.model.user?.profileURL {
                    self.profileUrlSubject.onNext(target)
                }
                
                if let target = self.dependency.model.desc {
                    self.descSubject.onNext(target)
                }

                if let target = self.dependency.model.user?.username {
                    self.usernameSubject.onNext(target)
                }
            })
            .disposed(by: self.disposeBag)
        self.tapProfileSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
            })
            .disposed(by: self.disposeBag)
    }
}
