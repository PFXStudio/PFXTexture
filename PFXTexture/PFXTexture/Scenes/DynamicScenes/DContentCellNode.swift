import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import TextureSwiftSupport

struct DContentData {
}

class DContentCellNode: ASCellNode {
    typealias Node = DContentCellNode
    
    struct Attribute {
        static let placeHolderColor: UIColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    private var nodes = [ASDisplayNode]()

    let disposeBag = DisposeBag()
    let id: Int
    let data: DContentData
    
    init(data: DContentData) {
        self.id = 1
        self.data = data
        super.init()
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true
        
        self.nodes.append(DTitleNode())
        self.nodes.append(DTitleNode())
        self.nodes.append(DTitleNode())
        self.nodes.append(DTitleNode())
    }
    
    override func layout() {
        super.layout()
        self.backgroundColor = UIColor.white
    }
}

extension DContentCellNode {
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
