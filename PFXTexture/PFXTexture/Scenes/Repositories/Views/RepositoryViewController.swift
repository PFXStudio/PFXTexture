import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class RepositoryViewController: ASDKViewController<ASTableNode> {
    private var items: [RxCellViewModel] = []
    private var context: ASBatchContext?
    var viewModel: RepositoryViewModel!
    
    private let disposeBag = DisposeBag()
    
    override init() {
        let tableNode = ASTableNode(style: .plain)
        tableNode.backgroundColor = .white
        tableNode.automaticallyManagesSubnodes = true
        super.init(node: tableNode)
        
        self.title = "Reposivarvary"
        
        // main thread
        self.node.onDidLoad({ node in
            guard let `node` = node as? ASTableNode else { return }
            node.view.separatorStyle = .singleLine
        })
        
        self.node.leadingScreensForBatching = 2.0
        self.node.dataSource = self
        self.node.delegate = self
        self.node.allowsSelectionDuringEditing = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.input.load.onNext(())
        
        self.viewModel.output.cellViewModels
            .asDriver(onErrorJustReturn: [RepositoryCellViewModel]())
            .drive(onNext: { [weak self] viewModels in
                guard let self = self, let viewModels = viewModels else { return }
                self.items.append(contentsOf: viewModels)
                self.node.reloadData()
            })
            .disposed(by: self.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RepositoryViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    /*
     Node Block Thread Safety Warning
     It is very important that node blocks be thread-safe.
     One aspect of that is ensuring that the data model is accessed outside of the node block.
     Therefore, it is unlikely that you should need to use the index inside of the block.
     */
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        return {
            guard self.items.count > indexPath.row else { return ASCellNode() }
            if let viewModel = self.items[indexPath.row] as? RepositoryCellViewModel {
                let cellNode = RepositoryListCellNode(viewModel: viewModel)
                
                return cellNode
            }
            if let viewModel = self.items[indexPath.row] as? RepositoryBannerCellViewModel {
                let cellNode = RepositoryBannerCellNode(viewModel: viewModel)
                
                return cellNode
            }
            
            return ASCellNode()
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        guard self.items.count > indexPath.row else { return ASCellNode() }
        if let viewModel = self.items[indexPath.row] as? RepositoryCellViewModel {
            return RepositoryListCellNode(viewModel: viewModel)
        }
        if let viewModel = self.items[indexPath.row] as? RepositoryBannerCellViewModel {
            return RepositoryBannerCellNode(viewModel: viewModel)
        }
        
        return ASCellNode()
    }
}

extension RepositoryViewController: ASTableDelegate {
    // block ASBatchContext active state
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return self.context == nil
    }
    
    // load more
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        self.context = context
        self.viewModel.input.load.onNext(())
    }
    
    // editable cell
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.node.performBatchUpdates({
                self.items.remove(at: indexPath.row)
                self.node.deleteRows(at: [indexPath], with: .fade)
            }, completion: nil)
        }
    }
}

extension RepositoryViewController {
    func openUserProfile(id: Int) {
        //        guard let index = self.items.index(where: { $0.id == id }) else { return }
        //        let viewModel = self.items[index]
        //        let viewController = UserProfileViewController(viewModel: viewModel)
        //        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

