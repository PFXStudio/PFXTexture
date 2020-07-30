import Foundation
import RxSwift
import RxCocoa

class RepositoryViewModel: RxViewModel, RxViewModelProtocol {
    struct Input {
        var load: AnyObserver<Void>
    }
    struct Output {
        var loading: Observable<Bool>
        var error: Observable<String>
        var cellViewModels: Observable<[RxCellViewModel]?>
    }
    
    struct Dependency {
    }
    var input: RepositoryViewModel.Input!
    var output: RepositoryViewModel.Output!
    var dependency: RepositoryViewModel.Dependency!
    private var loadSubject = PublishSubject<Void>()
    private var loadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<String>()
    private var cellViewModelsSubject = BehaviorRelay<[RxCellViewModel]?>(value: nil)
    
    private var lastId: Int? = nil
    private var items: [RepositoryViewModel] = []
    
    init(dependency: Dependency) {
        super.init()
        self.input = RepositoryViewModel.Input(load: self.loadSubject.asObserver()
        )
        self.output = RepositoryViewModel.Output(loading: self.loadingSubject.asObservable(),
                                                 error: self.errorSubject.asObservable(),
                                                 cellViewModels: self.cellViewModelsSubject.asObservable()
        )
        self.dependency = dependency
        self.bindInputs()
    }
    func bindInputs() {
        self.loadSubject
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let since = self.lastId
                _ = RepoService.loadRepository(params: [.since(since)])
                    .delay(0.5, scheduler: MainScheduler.asyncInstance)
                    .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
                    .map { $0.map { RepositoryCellViewModel(reuseIdentifier: "RepositoryCell", identifier: "RepositoryCell" + String.random(), dependency: RepositoryCellViewModel.Dependency(model: $0)) as RxCellViewModel } }
                    .observeOn(MainScheduler.instance)
                    .retry(3)
                    .subscribe(onSuccess: { [weak self] viewModels in
                        guard let self = self else { return }
                        var viewModels = viewModels
                        for i in stride(from: 0, to: viewModels.count, by: 6) {
                            if i == 0 { continue }
                            viewModels.insert(RepositoryBannerCellViewModel(reuseIdentifier: "RepositoryBannerCell", identifier: "RepositoryBannerCell" + String.random(), dependency: RepositoryBannerCellViewModel.Dependency()), at: i)
                        }
                        
                        for i in stride(from: 0, to: viewModels.count, by: 10) {
                            if i == 0 { continue }
                            viewModels.insert(RepositoryInfoCellViewModel(reuseIdentifier: "RepositoryInfoCell", identifier: "RepositoryInfoCell" + String.random(), dependency: RepositoryInfoCellViewModel.Dependency()), at: i)
                        }

                        if var cellViewModels = self.cellViewModelsSubject.value {
                            cellViewModels.append(contentsOf: viewModels)
                            self.cellViewModelsSubject.accept(cellViewModels)
                        }
                        else {
                            self.cellViewModelsSubject.accept(viewModels)
                        }
                        }, onError: { [weak self] error in
                            guard let self = self else { return }
                            self.errorSubject.onNext("error")
                    })
            })
            .disposed(by: self.disposeBag)
    }
}
