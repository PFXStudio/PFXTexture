import Foundation
import TextureSwiftSupport
import RxSwift

class DContentsNode: ASDisplayNode {
    private var viewModel: DContentsViewModel!
    private let disposeBag = DisposeBag()
    private lazy var favoriteButtonNode = { () -> ASButtonNode in
        let node = ASButtonNode()
        node.setAttributedTitle(NSAttributedString(string: "removeAll".localized(), attributes: DContentsNode.defaultButtonAttributes), for: .normal)
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
        node.setAttributedTitle(NSAttributedString(string: "refresh".localized(), attributes: attr), for: .normal)
        node.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.itemCellNodes.removeAll()
                self.setNeedsLayout()
                self.viewModel.input.load.onNext(())
            })
            .disposed(by: self.disposeBag)

        return node
    }()
    // filter buttons
    private var emptyNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.clipsToBounds = true
        node.maximumNumberOfLines = 0
        node.attributedText = NSAttributedString(string: "empty".localized())
        node.borderWidth = 1
        node.borderColor = UIColor.lightGray.cgColor
        return node
    }()
    
    private lazy var collectionNode = { () -> ASCollectionNode in
        let node = ASCollectionNode(collectionViewLayout: DContentsLayout(count: 0))
        node.allowsMultipleSelection = false
        node.showsHorizontalScrollIndicator = false
        node.delegate = self
        node.dataSource = self
        return node
    }()

    private var itemCellNodes = [DContentsNode.Cell]()

    init(viewModel: DContentsViewModel) {
        self.viewModel = viewModel
        super.init()
        self.buildNodeHierarchy()
        self.bindOutputs()
    }
    
    override func didLoad() {
        super.didLoad()
        self.viewModel.input.load.onNext(())
    }
    func bindOutputs() {
        self.viewModel.output
            .items
            .subscribe(onNext: { [weak self] responseModels in
                guard let self = self, let models = responseModels else { return }
                for model in models {
                    let cell = DContentsNode.Cell(model: model)
                    self.itemCellNodes.append(cell)
                }
                
                self.collectionNode.reloadData()
                self.setNeedsLayout()
            })
            .disposed(by: self.disposeBag)
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
    }
    
    // MARK: - Layout
    
    override func layout() {
        super.layout()
        
        self.backgroundColor = UIColor.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return LayoutSpec {
            VStackLayout(alignItems: .stretch) {
                HStackLayout(alignItems: .start) {
                    self.favoriteButtonNode.height(44)
                    InsetLayout(insets: UIEdgeInsets(top: 18, left: 16, bottom: 1, right: 16)) {
                        self.divNode.width(1.0).height(10.0)
                    }
                    self.recentButtonNode.height(44)
                    ASLayoutSpec()
                        .flexGrow(1.0)
                    self.allButtonNode.height(44.0)
                }
                .padding(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
                if self.itemCellNodes.count > 0 {
                    self.collectionNode.height(120).padding(0)
                }
                else {
                    CenterLayout {
                        self.emptyNode.padding(0).height(80)
                    }
                }
            }
            .padding(0)
        }
    }
}

extension DContentsNode: ASCollectionDataSource, ASCollectionDelegate {
    class DContentsLayout: UICollectionViewFlowLayout {

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
                self.itemSize = CGSize(width: 120, height: 120)
            }
            get {
                return CGSize(width: 120, height: 120)
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

extension DContentsNode {
    class Cell: ASCellNode {
        private var model: RepositoryModel!
        init(model: RepositoryModel) {
            super.init()
            self.model = model
            self.automaticallyManagesSubnodes = true
        }

        private lazy var imageNode = { () -> ASNetworkImageNode in
            let node = ASNetworkImageNode()
            guard let url = self.model.user?.profileURL else { return node }
            node.url = url
            node.clipsToBounds = true
            node.contentMode = .scaleAspectFit
            node.cornerRadius = 8.0
            return node
        }()
        

        private lazy var resionNode = { () -> ASTextNode in
            let node = ASTextNode()
            guard let desc = self.model.desc else { return node }
            node.clipsToBounds = true
            node.maximumNumberOfLines = 1

            let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                        NSAttributedString.Key.foregroundColor: UIColor.gray,
            ]
            
            node.attributedText = NSAttributedString(string: desc, attributes: attr)
            return node
        }()

        private lazy var nameNode = { () -> ASTextNode in
            let node = ASTextNode()
            guard let text = self.model.repositoryName else { return node }
            node.clipsToBounds = true
            node.maximumNumberOfLines = 0

            let attr = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
                        NSAttributedString.Key.foregroundColor: UIColor.gray,
            ]
            
            node.attributedText = NSAttributedString(string: text, attributes: attr)
            return node
        }()

        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            return LayoutSpec {
                // HStackLayout에 .flexGrow를 주면 VerticalCenter가 됨
                HStackLayout(alignItems: .start) {
                    self.imageNode.height(50).width(50)
                    VStackLayout(alignItems: .stretch) {
                        self.resionNode
                            .padding(UIEdgeInsets(top: 12, left: 0, bottom: 2, right: 0))
                        // nameNode에 .flexGrow를 주면 문자열 길이 상관 없이 공백까지 채워 줌.
                        self.nameNode.flexGrow(1.0)
                    }
                    .padding(0.0)
                }
                .height(200)
                .flexGrow(1.0)
            }
        }
    }
}

extension DContentsNode {
    static var defaultButtonAttributes = {
        return [NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
    }()
    
    static var selectedButtonAttributes = {
        return [NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
    }()
}
