import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import TextureSwiftSupport

struct DCellData {
}

class DCellNode: ASCellNode {
    typealias Node = DCellNode
    private lazy var nodes = { () -> [DContentsNode] in
        var results = [DContentsNode]()
        for i in 0..<5 {
            let node = DContentsNode(viewModel: DContentsViewModel(dependency: DContentsViewModel.Dependency(service: GithubService(), index: i)))
            results.append(node)
        }
        return results
    }()

    let disposeBag = DisposeBag()
    let id: Int
    let data: DCellData
    
    init(data: DCellData) {
        self.id = 1
        self.data = data
        super.init()
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true
    }
    
    override func layout() {
        super.layout()
        self.backgroundColor = UIColor.white
    }
}

extension DCellNode {
    // layout spec
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return LayoutSpec {
            // 패딩 값0에 alignItems: .stretch를 줘야 가로로 늘어남!!!
            VStackLayout(alignItems: .stretch) {
                self.nodes.padding(0)
            }
            .width(constrainedSize.max.width)
            .padding(0)
        }
    }
}
