import AsyncDisplayKit
import RxSwift

extension DViewController {
    class DLayout: UICollectionViewFlowLayout {
        override init() {
            super.init()
            //            self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            self.sectionHeadersPinToVisibleBounds = true
            self.setupLayout()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.setupLayout()
        }
        
        // MARK: - Layout
        
        private func setupLayout() {
            self.minimumInteritemSpacing = 0
            self.minimumLineSpacing = 0
            self.scrollDirection = .vertical
        }
        
        override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
            return self.collectionView!.contentOffset
        }
    }
}

class DViewController: ASDKViewController<ASCollectionNode>, ASCollectionDataSource, ASCollectionDelegate, ASCollectionDelegateFlowLayout {
    private var selectedIndex = 0
    private var collectionNode: ASCollectionNode {
        node.allowsMultipleSelection = false
        node.showsHorizontalScrollIndicator = false
        node.showsVerticalScrollIndicator = false
        node.delegate = self
        node.dataSource = self
        node.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        node.backgroundColor = UIColor.white
        
        return node
    }
    
    private var stickyHeaderNode: DStickyHeaderNode!
    private lazy var sections = { () -> [[ASCellNode]] in
        var results = [[ASCellNode]]()
        var nodes = [ASCellNode]()
        // section 0
        var node: ASCellNode = ExCellNode(data: ExData(title: "인포메이션 셀입니다.", desc: "다이나믹 셀\n클릭 해 보세요! 🤩"))
        node.backgroundColor = UIColor.orange
        nodes.append(node)
        results.append(nodes)
        
        self.stickyHeaderNode = DStickyHeaderNode(with: DStickyHeaderNode.Content(items: ["AA_A", "B_BB_B_BB", "C__C_C", "DD_D_D_D___DD", "E____E", "FF_F_F_F", "G_G_G_G"], selectedIndex: 0))
        self.stickyHeaderNode.selectedMenu = { [weak self] type in
            guard let self = self else { return }
            print(type)
            self.collectionNode.reloadData()
        }
        // section 1
        nodes = [ASCellNode]()
        node = ExCellNode(data: ExData(title: "인포메이션 셀입니다.", desc: "스티키 메뉴 영역이에용! 🥳"))
        node.isUserInteractionEnabled = false
        node.backgroundColor = UIColor.cyan
        nodes.append(node)
        
        node = DCellNode(data: DCellData())
        nodes.append(node)
        results.append(nodes)
        return results
    }()
    
    override init() {
        super.init(node: ASCollectionNode(collectionViewLayout: DLayout()))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    init(coordinator: HomeCoordinator) {
    //        self.coordinator = coordinator
    //        super.init(node: ASCollectionNode(collectionViewLayout: DLayout()))
    //    }
    
    //    required init?(coder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionNode.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            let sharedApplication = UIApplication.shared
            let statusBar = UIView(frame: (sharedApplication.delegate?.window??.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor.white
            sharedApplication.delegate?.window??.addSubview(statusBar)
            
            //            let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            //            statusBar.backgroundColor = UIColor.white
            //            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
        else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.white
        }
        
    }
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        super.viewDidDisappear(animated)
    //        coordinator?.removeDependency(coordinator)
    //    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.sections[section].count
    }
    
    func collectionView(_ collectionView: ASCollectionView, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let node = self.sections[indexPath.section][indexPath.row]
        node.setNeedsLayout()
        return node
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        if indexPath.section == 0 {
            return ASCellNode()
        }
        
        if self.stickyHeaderNode != nil {
            return self.stickyHeaderNode
        }
        
        return ASCellNode()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForFooterInSection section: Int) -> ASSizeRange {
        return ASSizeRangeZero
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
        if indexPath.section == 0 {
            return ASSizeRangeUnconstrained
        }
        return ASSizeRangeUnconstrained
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, sizeRangeForHeaderInSection section: Int) -> ASSizeRange {
        return ASSizeRangeUnconstrained
    }
}
