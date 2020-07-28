import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa

class RepositoryListCellNode: ASCellNode {
    typealias Node = RepositoryListCellNode
    
    struct Attribute {
        static let placeHolderColor: UIColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    private var viewModel: RepositoryCellViewModel!
    
    // nodes
    lazy var userProfileNode = { () -> ASNetworkImageNode in
        let node = ASNetworkImageNode()
        node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        node.cornerRadius = 25.0
        node.clipsToBounds = true
        node.placeholderColor = Attribute.placeHolderColor
        node.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        node.borderWidth = 0.5
        return node
    }()
    
    lazy var usernameNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.placeholderColor = Attribute.placeHolderColor
        return node
    }()
    
    lazy var descriptionNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.placeholderColor = Attribute.placeHolderColor
        node.maximumNumberOfLines = 0
//        node.truncationAttributedText = NSAttributedString(string: " ...More",
//                                                           attributes: Node.moreSeeAttributes)
        node.delegate = self
        node.isUserInteractionEnabled = true
        return node
    }()
    
    lazy var statusNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.placeholderColor = Attribute.placeHolderColor
        return node
    }()
    
    let disposeBag = DisposeBag()
    let id: Int
    
    init(viewModel: RepositoryCellViewModel) {
        self.id = viewModel.dependency.model.id
        super.init()
        self.viewModel = viewModel
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true

        // drive로 하면 안 됨. 백그라운드 쓰레드에서 처리 하게끔 되어 있나 봄
        self.viewModel.output.profileUrl
            .subscribe(onNext: { [weak self] url in
                guard let self = self else { return }
                self.userProfileNode.url = url
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.desc
            .subscribe(onNext: { [weak self] desc in
                guard let self = self else { return }
                let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 14.0)]
                let string = NSAttributedString(string: desc, attributes: attrs as [NSAttributedString.Key : Any])
                self.descriptionNode.attributedText = string
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.username
            .subscribe(onNext: { [weak self] name in
                guard let self = self else { return }
                let attrs = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
                let string = NSAttributedString(string: name, attributes: attrs as [NSAttributedString.Key : Any])
                self.usernameNode.attributedText = string
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.input.willDisplay.onNext(true)
        
//        userProfileNode.rx
//            .tap(to: viewModel.input.tapProfile)
//            .disposed(by: disposeBag)
    }
}

extension RepositoryListCellNode: ASTextNodeDelegate {
    func textNodeTappedTruncationToken(_ textNode: ASTextNode) {
        textNode.maximumNumberOfLines = 0
        self.setNeedsLayout()
    }
}

extension RepositoryListCellNode {
    // layout spec
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentLayout = contentLayoutSpec()
        contentLayout.style.flexShrink = 1.0
        contentLayout.style.flexGrow = 1.0
        
        userProfileNode.style.flexShrink = 1.0
        userProfileNode.style.flexGrow = 0.0
        
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 10.0,
                                            justifyContent: .start,
                                            alignItems: .center,
                                            children: [userProfileNode,
                                                       contentLayout])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0,
                                                      left: 10.0,
                                                      bottom: 10.0,
                                                      right: 10.0),
                                 child: stackLayout)
    }
    
    private func contentLayoutSpec() -> ASLayoutSpec {
        let elements = [self.usernameNode,
                        self.descriptionNode,
                        self.statusNode].filter { $0.attributedText?.length ?? 0 > 0 }
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 5.0,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: elements)
    }
}

extension RepositoryListCellNode {
    static var usernameAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
    }
    
    static var descAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
    }
    
    static var statusAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.gray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0)]
    }
    
    static var moreSeeAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .medium)]
    }
}
