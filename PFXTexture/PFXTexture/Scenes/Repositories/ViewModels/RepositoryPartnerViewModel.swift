import Foundation
import RxSwift
import RxCocoa

class RepositoryPartnerViewModel: RxViewModel, RxViewModelProtocol {
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
    var input: RepositoryPartnerViewModel.Input!
    var output: RepositoryPartnerViewModel.Output!
    var dependency: RepositoryPartnerViewModel.Dependency!
    private var loadSubject = PublishSubject<Void>()
    private var loadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<String>()
    private var cellViewModelsSubject = BehaviorRelay<[RxCellViewModel]?>(value: nil)
    
    private var lastId: Int? = nil
    private var items: [RepositoryPartnerViewModel] = []
    
    init(dependency: Dependency) {
        super.init()
        self.input = RepositoryPartnerViewModel.Input(load: self.loadSubject.asObserver()
        )
        self.output = RepositoryPartnerViewModel.Output(loading: self.loadingSubject.asObservable(),
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
                var viewModels = [RxCellViewModel]()
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

            })
            .disposed(by: self.disposeBag)
    }
}
