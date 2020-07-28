import Foundation
import UIKit
import RxSwift

protocol ConfigurableTableViewCellProtocol where Self: UITableViewCell {
    func configure(viewModel: RxCellViewModel, indexPath: IndexPath)
}

typealias ConfigurableTableViewCell = UITableViewCell & ConfigurableTableViewCellProtocol

class RxTableViewCell: ConfigurableTableViewCell {
    let hardImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    var disposeBag = DisposeBag()
    var indexPath: IndexPath?
    func deinitialize() {
        self.disposeBag = DisposeBag()
    }

    func configure(viewModel: RxCellViewModel, indexPath: IndexPath) {
        self.disposeBag = DisposeBag()
        self.indexPath = indexPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}
