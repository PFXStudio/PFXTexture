import Foundation
import RxSwift
import RxCocoa

class RepositoryInfoCellViewModel: RxCellViewModel, RxViewModelProtocol {
    struct Input {
        var willDisplay: AnyObserver<Bool>
    }
    struct Output {
        var loading: Observable<Bool>
        var error: Observable<String>
        var title: Observable<String>
        var desc: Observable<String>
        var contentsModels: Observable<[RepositoryInfoCellNode.Content]>
    }
    
    struct Dependency {
        var title = "인포 타이틀..."
        var desc = "인포 서브 타이틀입니다. 헷갈리지 마세욥!"
        var contents = [
            RepositoryInfoCellNode.Content(avatarUrl: URL(string: "http://d2tksqsghodazb.cloudfront.net/profile/201607/20160706/48c425a3-d6fa-4ae8-8b80-8ad24efaa361.PNG")!, title: "😭", subtitle: String.random(length: 128), unreadItems: 3),
            RepositoryInfoCellNode.Content(avatarUrl: URL(string: "http://d2tksqsghodazb.cloudfront.net/profile/201607/20160706/48c425a3-d6fa-4ae8-8b80-8ad24efaa361.PNG")!, title: "👀", subtitle: String.random(length: 256), unreadItems: 3),
            RepositoryInfoCellNode.Content(avatarUrl: URL(string: "http://d2tksqsghodazb.cloudfront.net/profile/201607/20160706/48c425a3-d6fa-4ae8-8b80-8ad24efaa361.PNG")!, title: "😱", subtitle: String.random(length: 512), unreadItems: 3)
        ]
    }
    var input: RepositoryInfoCellViewModel.Input!
    var output: RepositoryInfoCellViewModel.Output!
    var dependency: RepositoryInfoCellViewModel.Dependency!
    private var willDisplaySubject = PublishSubject<Bool>()
    private var loadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<String>()
    private var titleSubject = PublishSubject<String>()
    private var descSubject = PublishSubject<String>()
    private var contentsSubject = PublishSubject<[RepositoryInfoCellNode.Content]>()

    init(reuseIdentifier: String, identifier: String, dependency: Dependency) {
        super.init(reuseIdentifier: reuseIdentifier, identifier: identifier)
        self.dependency = dependency
        self.initialize()
    }

    override func initialize() {
        super.initialize()
        // swiftlint:disable line_length
        self.input = RepositoryInfoCellViewModel.Input(willDisplay: self.willDisplaySubject.asObserver()
        )
        self.output = RepositoryInfoCellViewModel.Output(loading: self.loadingSubject.asObservable(),
                                           error: self.errorSubject.asObservable(),
                                           title: self.titleSubject.asObservable(),
                                           desc: self.descSubject.asObservable(),
                                           contentsModels: self.contentsSubject.asObservable()
        )
        // swiftlint:enable line_length
        
        self.bindInputs()
    }
    
    func bindInputs() {
        self.willDisplaySubject
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                self.titleSubject.onNext(self.dependency.title)
                self.descSubject.onNext(self.dependency.desc)
                self.contentsSubject.onNext(self.dependency.contents)
            })
            .disposed(by: self.disposeBag)
    }
}
