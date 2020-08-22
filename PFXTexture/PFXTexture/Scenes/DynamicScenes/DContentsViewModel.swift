import Foundation
import RxSwift
import RxDataSources
import RxRelay
import TextureSwiftSupport

class DContentsViewModel: RxViewModel, RxViewModelProtocol {
    struct Input {
        var load: AnyObserver<Void>
    }
    
    struct Output {
        var loading: Observable<Bool>
        var error: Observable<String>
        var items: Observable<[RepositoryModel]?>
    }
    
    struct Dependency {
        var service: GithubProtocol!
        var index = 0
    }
    
    var input: DContentsViewModel.Input!
    var output: DContentsViewModel.Output!
    var dependency: DContentsViewModel.Dependency!
    private var loadSubject = PublishSubject<Void>()
    private var loadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<String>()
    private var itemsSubject = BehaviorRelay<[RepositoryModel]?>(value: nil)
    private var hasNext = true
    override func deinitialize() {
        super.deinitialize()
    }
    
    init(dependency: Dependency) {
        super.init()
        
        self.input = DContentsViewModel.Input(load: self.loadSubject.asObserver()
        )
        self.output = DContentsViewModel.Output(loading: self.loadingSubject.asObservable(),
                                           error: self.errorSubject.asObservable(),
                                           items: self.itemsSubject.asObservable()
        )
        
        self.dependency = dependency
        self.bindInputs()
    }
    
    func bindInputs() {
        self.loadSubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dependency.service.loadRepository(params: [.since(self.dependency.index * 100)])
                    .subscribe(onSuccess: { [weak self] responseModels in
                        guard let self = self else { return }
                        if var models = self.itemsSubject.value {
                            models.append(contentsOf: responseModels)
                            self.itemsSubject.accept(models)
                        }
                        else {
                            self.itemsSubject.accept(responseModels)
                        }
                    }) { [weak self] error in
                        guard let self = self else { return }
                }
                .disposed(by: self.disposeBag)
            })
            .disposed(by: self.disposeBag)
    }
}

