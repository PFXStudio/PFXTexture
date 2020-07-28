import Foundation
import RxDataSources

struct RxSectionTableViewModel : AnimatableSectionModelType, IdentifiableType, Equatable {

    static func == (lhs: RxSectionTableViewModel, rhs: RxSectionTableViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    var identifier = String.random(length: 20)

    var header: String? = ""

    var items: [RxCellViewModel]

    init(header: String? = "", items: [RxCellViewModel] = []) {
        self.header = header
        self.items = items
    }

    // MARK: -

    var identity: String {
        return identifier
    }

    typealias Identity = String

    typealias Item = RxCellViewModel

    init(original: RxSectionTableViewModel, items: [Item]) {
        self = original
        self.items = items
    }
}
