import Foundation
import UIKit
import RxSwift

protocol ConfigurableCollectionViewCellProtocol where Self: UICollectionViewCell {
    func configure(viewModel: RxCellViewModel, indexPath: IndexPath)
}

typealias ConfigurableCollectionViewCell = UICollectionViewCell & ConfigurableCollectionViewCellProtocol

class RxCollectionViewCell: ConfigurableCollectionViewCell {
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
