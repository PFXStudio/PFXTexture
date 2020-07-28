import Foundation
import RxSwift
import RxCocoa

class RepositoryBannerCellViewModel: RxCellViewModel, RxViewModelProtocol {
    struct Input {
        var willDisplay: AnyObserver<Bool>
    }
    struct Output {
        var loading: Observable<Bool>
        var error: Observable<String>
        var title: Observable<String>
        var desc: Observable<String>
        var partnerModels: Observable<[PartnerModel]>
    }
    
    struct Dependency {
        var title = "섹션 타이틀 제목"
        var desc = "원하는 아이템을 선택 해 보세요!"
        var partnerModels = [
            PartnerModel(region: "아아아아아아아", name: String.random(), star: "4.5", commentCount: "444", thumbnailUrl: URL(string: "http://d2tksqsghodazb.cloudfront.net/profile/201607/20160706/48c425a3-d6fa-4ae8-8b80-8ad24efaa361.PNG")!),
            PartnerModel(region: "캬캬캬캬챷퍄캬캬챠", name: String.random(), star: "4.5", commentCount: "444", thumbnailUrl: URL(string: "http://d2tksqsghodazb.cloudfront.net/profile/201607/20160706/48c425a3-d6fa-4ae8-8b80-8ad24efaa361.PNG")!),
            PartnerModel(region: "애내채타파얃93야패", name: String.random(), star: "4.5", commentCount: "444", thumbnailUrl: URL(string: "http://d2tksqsghodazb.cloudfront.net/profile/201607/20160706/48c425a3-d6fa-4ae8-8b80-8ad24efaa361.PNG")!)
        ]
    }
    var input: RepositoryBannerCellViewModel.Input!
    var output: RepositoryBannerCellViewModel.Output!
    var dependency: RepositoryBannerCellViewModel.Dependency!
    private var willDisplaySubject = PublishSubject<Bool>()
    private var loadingSubject = PublishSubject<Bool>()
    private var errorSubject = PublishSubject<String>()
    private var titleSubject = PublishSubject<String>()
    private var descSubject = PublishSubject<String>()
    private var partnerModelsSubject = PublishSubject<[PartnerModel]>()

    init(reuseIdentifier: String, identifier: String, dependency: Dependency) {
        super.init(reuseIdentifier: reuseIdentifier, identifier: identifier)
        self.dependency = dependency
        self.initialize()
    }

    override func initialize() {
        super.initialize()
        // swiftlint:disable line_length
        self.input = RepositoryBannerCellViewModel.Input(willDisplay: self.willDisplaySubject.asObserver()
        )
        self.output = RepositoryBannerCellViewModel.Output(loading: self.loadingSubject.asObservable(),
                                           error: self.errorSubject.asObservable(),
                                           title: self.titleSubject.asObservable(),
                                           desc: self.descSubject.asObservable(),
                                           partnerModels: self.partnerModelsSubject.asObservable()
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
                self.partnerModelsSubject.onNext(self.dependency.partnerModels)
            })
            .disposed(by: self.disposeBag)
    }
}
