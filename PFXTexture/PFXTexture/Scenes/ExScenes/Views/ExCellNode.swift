import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import TextureSwiftSupport

struct ExData {
    var title = ""
    var desc = ""
    var imagePath = ""
}

class ExCellNode: ASCellNode {
    typealias Node = ExCellNode
    
    struct Attribute {
        static let placeHolderColor: UIColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    var descNodes = [ASTextNode]()
    var imageNodes = [ASNetworkImageNode]()
    
    lazy var titleNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.placeholderColor = Attribute.placeHolderColor
        node.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let descNode = ASTextNode()
                descNode.maximumNumberOfLines = 0
                descNode.placeholderColor = Attribute.placeHolderColor
                descNode.attributedText = NSAttributedString(string: String.random(length: 128), attributes: Self.descAttributes)
                self.descNodes.append(descNode)
                
                let imageNode = ASNetworkImageNode()
                imageNode.cornerRadius = 25.0
                imageNode.clipsToBounds = true
                imageNode.placeholderColor = Attribute.placeHolderColor
                imageNode.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
                imageNode.borderWidth = 0.5
                self.imageNodes.append(imageNode)
                
                self.setNeedsLayout()
            })
            .disposed(by: self.disposeBag)
        node.attributedText = NSAttributedString(string: self.data.desc, attributes: Self.usernameAttributes)
        return node
    }()
    
    let disposeBag = DisposeBag()
    let id: Int
    let data: ExData
    
    init(data: ExData) {
        self.id = 1
        self.data = data
        super.init()
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true

        // drive로 하면 안 됨. 백그라운드 쓰레드에서 처리 하게끔 되어 있나 봄
        /*
        self.viewModel.output.profileUrl
            .subscribe(onNext: { [weak self] url in
                guard let self = self else { return }
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
        */
//        userProfileNode.rx
//            .tap(to: viewModel.input.tapProfile)
//            .disposed(by: disposeBag)
    }
}

extension ExCellNode: ASTextNodeDelegate {
    func textNodeTappedTruncationToken(_ textNode: ASTextNode) {
        textNode.maximumNumberOfLines = 0
        self.setNeedsLayout()
    }
}

extension ExCellNode {
    // layout spec
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentLayout = contentLayoutSpec()
        contentLayout.style.flexShrink = 1.0
        contentLayout.style.flexGrow = 1.0
        
        let titleSpec = ASStackLayoutSpec(direction: .vertical,
                                 spacing: 5.0,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: [self.titleNode])
        
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 10.0,
                                            justifyContent: .start,
                                            alignItems: .center,
                                            children: [titleSpec, contentLayout])
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0,
                                                      left: 10.0,
                                                      bottom: 10.0,
                                                      right: 10.0),
                                 child: stackLayout)
    }
    
    private func contentLayoutSpec() -> ASLayoutSpec {
        var elements = [ASDisplayNode]()
        for i in self.imageNodes.indices {
            let textNode = self.descNodes[i]
            let imageNode = self.imageNodes[i]
            elements.append(textNode)
            elements.append(imageNode)
        }
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 5.0,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: elements)
    }
}

extension ExCellNode {
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
