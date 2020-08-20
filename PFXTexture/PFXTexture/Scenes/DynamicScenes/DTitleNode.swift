import Foundation
import TextureSwiftSupport
import RxSwift

class DTitleNode: ASDisplayNode {
    private let disposeBag = DisposeBag()
    private lazy var favoriteButtonNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.setAttributedTitle(NSAttributedString(string: "removeAll".localized(), attributes: DTitleNode.defaultButtonAttributes), for: .normal)
        node.clipsToBounds = true
        node.rx.tap
            .subscribe(onNext: { _ in
                print("\(#function) : \(#line)")
                self.itemCellNodes.removeAll()
                self.collectionNode.reloadData()
                self.setNeedsLayout()
            })
            .disposed(by: self.disposeBag)
        return node
    }()
    private var divNode = { () -> ASDisplayNode in
        let node = ASDisplayNode()
        node.backgroundColor = UIColor.gray
        node.clipsToBounds = false
        
        return node
    }()
    private lazy var recentButtonNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.clipsToBounds = true
        node.rx.tap
            .subscribe(onNext: { _ in
                print("\(#function) : \(#line)")
                self.itemCellNodes.removeAll()
            })
            .disposed(by: self.disposeBag)

        return node
    }()
    
    private lazy var allButtonNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.clipsToBounds = true
        let attr = [
                    NSAttributedString.Key.foregroundColor: UIColor.gray]
        node.setAttributedTitle(NSAttributedString(string: "addItem".localized(), attributes: attr), for: .normal)
        node.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.itemCellNodes.append(DTitleNode.Cell(itemInfo: ExData(title: String.random(length: 10), desc: String.random(length: 16), imagePath: "")))
                self.collectionNode.reloadData()
                self.setNeedsLayout()
            })
            .disposed(by: self.disposeBag)

        return node
    }()
    // filter buttons
    private lazy var studioButtonNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.clipsToBounds = true
        node.rx.tap
            .subscribe(onNext: { _ in
                print("\(#function) : \(#line)")
            })
            .disposed(by: self.disposeBag)
        return node
    }()
    private lazy var dressButtonNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.clipsToBounds = true
        node.rx.tap
            .subscribe(onNext: { _ in
                print("\(#function) : \(#line)")
            })
            .disposed(by: self.disposeBag)
        return node
    }()
    private lazy var makeupButtonNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.clipsToBounds = true
        node.rx.tap
            .subscribe(onNext: { _ in
                print("\(#function) : \(#line)")
            })
            .disposed(by: self.disposeBag)
        return node
    }()
    private lazy var snapButtonNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.clipsToBounds = true
        node.rx.tap
            .subscribe(onNext: { _ in
                print("\(#function) : \(#line)")
            })
            .disposed(by: self.disposeBag)
        return node
    }()

    private var toggleNode = { () -> ASDisplayNode in
        let node = ASDisplayNode()
        node.clipsToBounds = true
        return node
    }()
    
    private var emptyNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.clipsToBounds = true
        node.maximumNumberOfLines = 0
        
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        let attributedString = NSMutableAttributedString(string: "emptyFavoriteSee".localized(), attributes: [
            .foregroundColor: UIColor.gray,
            .kern: 0.0,
            .paragraphStyle : style
        ])
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 0, length: 13))
        node.attributedText = attributedString
        return node
    }()
    
    private lazy var collectionNode = { () -> ASCollectionNode in
        let node = ASCollectionNode(collectionViewLayout: SRecentLayout(count: 0))
        node.allowsMultipleSelection = false
        node.showsHorizontalScrollIndicator = false
        node.delegate = self
        node.dataSource = self
        return node
    }()

    private var itemCellNodes = [DTitleNode.Cell]()

    override init() {
        super.init()
        
        self.buildNodeHierarchy()
        self.bindOutputs()
    }
    
    func bindOutputs() {
    }
    
    override func asyncTraitCollectionDidChange(withPreviousTraitCollection previousTraitCollection: ASPrimitiveTraitCollection) {
        print(">>> ??")
        //        locationNode.imageNode.image = Config.Images.profileLocation
        //        emailNode.imageNode.image = Config.Images.profileEnvelope
        //        linkNode.imageNode.image = Config.Images.profileLink
        //        companyNode.imageNode.image = Config.Images.profileCompany
    }
    
    // MARK: - Build node hierarchy
    private func buildNodeHierarchy() {
        self.automaticallyManagesSubnodes = true
        [self.emptyNode, self.collectionNode, self.allButtonNode, self.recentButtonNode, self.favoriteButtonNode].forEach { (node) in
            self.addSubnode(node)
        }
    }
    
    // MARK: - Layout
    
    override func layout() {
        super.layout()
        
        self.backgroundColor = UIColor.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return LayoutSpec {
            VStackLayout(alignItems: .stretch) {
                HStackLayout(alignItems: .stretch) {
                    self.favoriteButtonNode.height(44)
                    InsetLayout(insets: UIEdgeInsets(top: 17, left: 16, bottom: 1, right: 16)) {
                        self.divNode.width(1.0).height(10.0)
                    }
                    self.recentButtonNode.height(44)
                    ASLayoutSpec()
                        .flexGrow(1.0)
                    self.allButtonNode.height(44.0)
                }
                .padding(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
                if self.itemCellNodes.count > 0 {
                    self.collectionNode.height(100).padding(0)
                }
                else {
                    self.emptyNode.height(150).padding(.top, 50)
                }
            }
            .padding(0)
        }
    }
}

extension DTitleNode: ASCollectionDataSource, ASCollectionDelegate {
    class SRecentLayout: UICollectionViewFlowLayout {

        // MARK: - Variables
        
        var numberOfColumns: CGFloat = 0
        
        // MARK: - Object life cycle
        
        init(count: CGFloat) {
            super.init()
            self.numberOfColumns = count
            self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            self.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

            self.setupLayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.setupLayout()
        }
        
        override var itemSize: CGSize {
            set {
                self.itemSize = CGSize(width: 120, height: 200)
            }
            get {
                return CGSize(width: 120, height: 200)
            }
        }

        // MARK: - Layout
        
        private func setupLayout() {
            self.minimumInteritemSpacing = 12
            self.minimumLineSpacing = 12
            self.scrollDirection = .horizontal
        }
        
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
            return self.collectionView!.contentOffset
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemCellNodes.count
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let node = self.itemCellNodes[indexPath.row]
        return node
    }
}

extension DTitleNode {
    class Cell: ASCellNode {
        private var itemInfo: ExData!
        init(itemInfo: ExData) {
            super.init()
            self.itemInfo = itemInfo
            self.automaticallyManagesSubnodes = true
        }

        private lazy var resionNode = { () -> ASTextNode in
            let node = ASTextNode()
            node.clipsToBounds = true
            node.maximumNumberOfLines = 1

            let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
                        NSAttributedString.Key.foregroundColor: UIColor.gray,
            ]
            
            node.attributedText = NSAttributedString(string: self.itemInfo.desc, attributes: attr)
            return node
        }()

        private lazy var nameNode = { () -> ASTextNode in
            let node = ASTextNode()
            node.clipsToBounds = true
            node.maximumNumberOfLines = 0

            let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                        NSAttributedString.Key.foregroundColor: UIColor.gray,
            ]
            
            node.attributedText = NSAttributedString(string: self.itemInfo.title, attributes: attr)
            return node
        }()

        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            return LayoutSpec {
                // HStackLayout에 .flexGrow를 주면 VerticalCenter가 됨
                VStackLayout(alignItems: .start) {
                    self.resionNode
                        .padding(UIEdgeInsets(top: 12, left: 0, bottom: 2, right: 0))
                    // nameNode에 .flexGrow를 주면 문자열 길이 상관 없이 공백까지 채워 줌.
                    self.nameNode.flexGrow(1.0)
                }
                .height(200)
                .flexGrow(1.0)
            }
        }
    }
}

extension DTitleNode {
    static var defaultButtonAttributes = {
        return [NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
    }()
    
    static var selectedButtonAttributes = {
        return [NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
    }()
}
