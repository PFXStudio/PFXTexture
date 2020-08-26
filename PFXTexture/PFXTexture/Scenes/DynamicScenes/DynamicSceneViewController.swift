import Foundation
import UIKit
import SnapKit

class DynamicSceneViewController: UIViewController {
    @IBOutlet weak var bgndView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let node = DynamicNode()
        self.bgndView.addSubnode(node)
        node.view.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
