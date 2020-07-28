import Foundation
import RxDataSources
import RxSwift

public class RxCellViewModel: NSObject, IdentifiableType {
    let reuseIdentifier: String
    let identifier: String
    var disposeBag = DisposeBag()
    func deinitialize() {
        self.disposeBag = DisposeBag()
    }
    func initialize() {
        self.disposeBag = DisposeBag()
    }

    init(reuseIdentifier: String, identifier: String) {
        self.reuseIdentifier = reuseIdentifier
        self.identifier = identifier
        self.disposeBag = DisposeBag()
    }
    
    // MARK: - IdentifiableType

    public typealias Identity = String

    public var identity : Identity {
        return identifier
    }

    // MARK: - Equatable

    public static func == (lhs: RxCellViewModel, rhs: RxCellViewModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
