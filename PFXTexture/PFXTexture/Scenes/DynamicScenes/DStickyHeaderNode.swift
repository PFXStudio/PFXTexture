import AsyncDisplayKit
import TextureSwiftSupport
import RxSwift
import RxCocoa
import RxCocoa_Texture

class DStickyHeaderNode: ASCellNode {
    // MARK: - Variables
    struct Content {
        var items: Array<String> = []
        var selectedIndex = 0
    }
    private var content: Content
    private let disposeBag = DisposeBag()
    var selectedMenu: ((_ type: Int) -> Void)? = nil

    class HomeMenuLayout: UICollectionViewFlowLayout {
        var numberOfColumns: CGFloat = 0
        init(count: CGFloat) {
            super.init()
            self.numberOfColumns = count
            self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            self.setupLayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.setupLayout()
        }
        
        // MARK: - Layout
        
        private func setupLayout() {
            self.minimumInteritemSpacing = 5
            self.minimumLineSpacing = 0
            self.scrollDirection = .horizontal
        }
        
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
            return self.collectionView!.contentOffset
        }
    }
    
    private lazy var collectionNode = { () -> ASCollectionNode in
        let node = ASCollectionNode(collectionViewLayout: HomeMenuLayout(count: CGFloat(self.content.items.count)))
        node.allowsMultipleSelection = false
        node.showsHorizontalScrollIndicator = false
        node.delegate = self
        node.dataSource = self
        node.backgroundColor = UIColor.white

        return node
    }()
    private lazy var divNode = { () -> ASDisplayNode in
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.gray

        return node
    }()

    private lazy var itemCellNodes = { () -> [ASCellNode] in
        var nodes = [ASCellNode]()
        for i in content.items.indices {
            let item = self.content.items[i]
            if item.count > 0 {
                let node = TextNode(text: item)
                nodes.append(node)
            }
        }
        
        return nodes
    }()
    
    init(with content: Content) {
        self.content = content
        
        super.init()
        self.selectionStyle = .none
        
        self.buildNodeHierarchy()
    }
    
    func configureCell(with content: Content) {
        self.content = content
    }

    override func asyncTraitCollectionDidChange(withPreviousTraitCollection previousTraitCollection: ASPrimitiveTraitCollection) {
        print(">>> ??")
//        locationNode.imageNode.image = Config.Images.profileLocation
//        emailNode.imageNode.image = Config.Images.profileEnvelope
//        linkNode.imageNode.image = Config.Images.profileLink
//        companyNode.imageNode.image = Config.Images.profileCompany
    }
    
    // MARK: - Setup nodes
    
    private var dayTextAttributes = {
        return [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 22),
                NSAttributedString.Key.foregroundColor: UIColor.gray]
    }()
    
    // MARK: - Build node hierarchy
    private func buildNodeHierarchy() {
        self.automaticallyManagesSubnodes = true
    }
    
//    private var underLine = CALayer()
    override func layout() {
        super.layout()
        self.clipsToBounds = false
        self.collectionNode.backgroundColor = UIColor.white
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return LayoutSpec {
            VStackLayout(justifyContent: .start, alignItems: .stretch) {
                VStackLayout() {
                    OverlayLayout(content: {
                        HStackLayout(alignItems: .stretch) {
                            self.collectionNode.padding(0).height(66).flexGrow(1.0)
                        }
                        .padding(0)
                    }) {
                        HStackLayout(alignItems: .stretch) {
                            self.divNode.padding(0).height(1).flexGrow(1.0)
                        }
                        .padding(.top, 60)
                        .height(1.0)
                    }
                }
                .padding(0)
            }
            .height(76.0)
            .padding(0.0)
        }
    }
}

extension DStickyHeaderNode: ASCollectionDataSource, ASCollectionDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCellNodes.count
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let node = self.itemCellNodes[indexPath.row]
        return node
    }

    // 시작 시 선택 셀은 여기서 해야 함, cellNode에서 반드시 layoutIfNeeded 호출 해 줘야 그려짐.
    func collectionNode(_ collectionNode: ASCollectionNode, willDisplayItemWith node: ASCellNode) {
        if let sender = node as? DStickyHeaderNodeProtocol {
            sender.deselected()
            if node == self.itemCellNodes[self.content.selectedIndex] {
                sender.selected()
                return
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.content.selectedIndex == indexPath.row { return }
        for node in self.itemCellNodes {
            if let node = node as? DStickyHeaderNodeProtocol {
                node.deselected()
            }
        }

        self.content.selectedIndex = indexPath.row
        let node = self.itemCellNodes[indexPath.row]
        if let node = node as? DStickyHeaderNodeProtocol {
            node.selected()
        }

        guard let selectedMenu = self.selectedMenu else { return }
        selectedMenu(indexPath.row)
    }
}
// sub nodes
protocol DStickyHeaderNodeProtocol {
    func selected()
    func deselected()
}
extension DStickyHeaderNode {
    class ImageNode: ASCellNode, DStickyHeaderNodeProtocol {
        private var image: UIImage!
        init(image: UIImage) {
            super.init()
            self.image = image
            self.automaticallyManagesSubnodes = true
        }

        private lazy var imageNode = { () -> ASImageNode in
            let node = ASImageNode()
            node.image = self.image
            node.clipsToBounds = true
            node.contentMode = .scaleAspectFit
            return node
        }()
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            return LayoutSpec {
                // HStackLayout에 .flexGrow를 주면 VerticalCenter가 됨
                VStackLayout(alignItems: .center) {
                    // imageNode에 .flexGrow를 주면 HorizontalCenter가 됨
                    self.imageNode.minSize(CGSize(width: 39, height: 15))
                        .padding(UIEdgeInsets(top: 4, left: 16, bottom: 0, right: 16))
                        .flexGrow(1.0)
                }
                .height(56)
                .flexGrow(1.0)
            }
        }
        
        private var underLine = CALayer()
        func selected() {
            defer {
                self.setNeedsLayout()
            }
            self.layoutIfNeeded()
            self.underLine = self.imageNode.view.addBottomBorderWithColor(color: UIColor.black, width: 2)
            self.underLine.cornerRadius = 1
        }
        func deselected() {
            defer {
                self.setNeedsLayout()
            }
            self.layoutIfNeeded()
            self.underLine.removeFromSuperlayer()
        }
    }

    class TextNode: ASCellNode, DStickyHeaderNodeProtocol {
        private var text = ""
        init(text: String) {
            super.init()
            self.text = text
            self.automaticallyManagesSubnodes = true
        }
        
        private lazy var textNode = { () -> ASTextNode in
            let node = ASTextNode()
            node.clipsToBounds = true
            node.maximumNumberOfLines = 1

            let style = NSMutableParagraphStyle()
            style.alignment = .center
            let attr = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor: UIColor.gray,
                        NSAttributedString.Key.paragraphStyle : style
            ]
            
            node.attributedText = NSAttributedString(string: self.text, attributes: attr)
            return node
        }()

        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            return LayoutSpec {
                VStackLayout() {
                    self.textNode.padding(UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)).flexGrow(1.0)
                }
                .minHeight(56)
                .flexGrow(1.0)
            }
        }

        private var underLine = CALayer()
        func selected() {
            defer {
                self.setNeedsLayout()
            }
            self.layoutIfNeeded()
            self.underLine.removeFromSuperlayer()
            self.underLine = self.textNode.view.addBottomBorderWithColor(color: UIColor.black, width: 2)
            self.underLine.cornerRadius = 1
        }
        func deselected() {
            defer {
                self.setNeedsLayout()
            }
            self.layoutIfNeeded()
            self.underLine.removeFromSuperlayer()
            self.underLine = self.textNode.view.addBottomBorderWithColor(color: UIColor.clear, width: 0)
        }
    }
}


