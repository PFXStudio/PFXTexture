import Foundation
import AsyncDisplayKit
import RxSwift
import RxCocoa
import GTTexture_RxExtension

struct ExData {
    var title = ""
    var desc = ""
}

class ExCellNode: ASCellNode {
    typealias Node = ExCellNode
    
    struct Attribute {
        static let placeHolderColor: UIColor = UIColor.gray.withAlphaComponent(0.2)
    }
    
    private var partnerModels = [PartnerModel]()
    private var imageNodes = [ASDisplayNode]()
    private var textNodes = [ASDisplayNode]()
    
    lazy var titleNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.maximumNumberOfLines = 1
        node.placeholderColor = Attribute.placeHolderColor
        node.attributedText = NSAttributedString(string: self.data.title, attributes: Self.titleAttributes)
        node.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                var node = ASNetworkImageNode()
                node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
                node.cornerRadius = 8
                node.clipsToBounds = true
                node.placeholderColor = Attribute.placeHolderColor
                node.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
                node.borderWidth = 0.5

                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    node.url = URL(string: "http://d2tksqsghodazb.cloudfront.net/profile/201607/20160706/48c425a3-d6fa-4ae8-8b80-8ad24efaa361.PNG")!
                })
                self.imageNodes.append(node)
                
                let textNode = ASTextNode()
                textNode.placeholderColor = Attribute.placeHolderColor
                textNode.maximumNumberOfLines = 0
                //        node.truncationAttributedText = NSAttributedString(string: " ...More",
                //                                                           attributes: Node.moreSeeAttributes)
                textNode.delegate = self
                textNode.isUserInteractionEnabled = true
                textNode.attributedText = NSAttributedString(string: "+++", attributes: Self.descAttributes)
                self.textNodes.append(textNode)
                
                self.setNeedsLayout()
            })
            .disposed(by: self.disposeBag)
        return node
    }()
    
    lazy var descriptionNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.placeholderColor = Attribute.placeHolderColor
        node.maximumNumberOfLines = 1
        //        node.truncationAttributedText = NSAttributedString(string: " ...More",
        //                                                           attributes: Node.moreSeeAttributes)
        node.delegate = self
        node.isUserInteractionEnabled = true
        node.attributedText = NSAttributedString(string: self.data.desc, attributes: Self.descAttributes)
        return node
    }()
    
    lazy var nameNode = { () -> ASTextNode in
        let node = ASTextNode()
        node.placeholderColor = Attribute.placeHolderColor
        node.maximumNumberOfLines = 1
        //        node.truncationAttributedText = NSAttributedString(string: " ...More",
        //                                                           attributes: Node.moreSeeAttributes)
        node.delegate = self
        node.isUserInteractionEnabled = true
        return node
    }()
    
    
    let disposeBag = DisposeBag()
    private var data: ExData
    
    init(data: ExData) {
        self.data = data
        super.init()
        self.selectionStyle = .none
        self.backgroundColor = .white
        self.automaticallyManagesSubnodes = true
        
        // drive로 하면 안 됨. 백그라운드 쓰레드에서 처리 하게끔 되어 있나 봄
        /*
        self.viewModel.output.title
            .subscribe(onNext: { [weak self] title in
                guard let self = self else { return }
                self.titleNode.attributedText = NSAttributedString(string: title, attributes: Self.titleAttributes)
            })
            .disposed(by: self.disposeBag)
        self.viewModel.output.desc
            .subscribe(onNext: { [weak self] desc in
                guard let self = self else { return }
                self.descriptionNode.attributedText = NSAttributedString(string: desc, attributes: Self.titleAttributes)
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.partnerModels
            .subscribe(onNext: { [weak self] partnerModels in
                guard let self = self else { return }
                self.partnerModels = partnerModels
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
        var specs = [ASLayoutSpec]()
        let contentLayout = contentLayoutSpec()
        contentLayout.style.flexShrink = 1.0
        contentLayout.style.flexGrow = 1.0
        
        specs.append(contentLayout)
        for model in self.partnerModels {
            let partnerLayout = partnerLayoutSpec(model: model)
            specs.append(partnerLayout)
        }
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 10.0,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: specs)
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0,
                                                      left: 10.0,
                                                      bottom: 10.0,
                                                      right: 10.0),
                                 child: stackLayout)
    }
    
    private func contentLayoutSpec() -> ASLayoutSpec {
        let elements = [self.titleNode,
                        self.descriptionNode
            ].filter { $0.attributedText?.length ?? 0 > 0 }
        
        let infoLayout = ASStackLayoutSpec(direction: .vertical,
        spacing: 5.0,
        justifyContent: .start,
        alignItems: .stretch,
        children: elements)
        
        let subLayout = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 10.0,
                                           justifyContent: .start,
                                           alignItems: .stretch,
                                           children: self.textNodes + self.imageNodes)
        

        
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 10.0,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: [infoLayout, subLayout]
        )
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0,
                                                      left: 10.0,
                                                      bottom: 10.0,
                                                      right: 10.0),
                                 child: stackLayout)
    }
    
    private func partnerLayoutSpec(model: PartnerModel) -> ASLayoutSpec {
        let node = ASNetworkImageNode()
        node.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        node.cornerRadius = 8
        node.clipsToBounds = true
        node.placeholderColor = Attribute.placeHolderColor
        node.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        node.borderWidth = 0.5
        node.url = model.thumbnailUrl
        
        let regionNode = ASTextNode()
        regionNode.maximumNumberOfLines = 1
        regionNode.placeholderColor = Attribute.placeHolderColor
        regionNode.attributedText = NSAttributedString(string: model.region, attributes: Self.descAttributes)
        
        let nameNode = ASTextNode()
        nameNode.maximumNumberOfLines = 1
        nameNode.placeholderColor = Attribute.placeHolderColor
        nameNode.attributedText = NSAttributedString(string: model.name, attributes: Self.descAttributes)
        nameNode.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let _ = self else { return }
                nameNode.maximumNumberOfLines = nameNode.maximumNumberOfLines == 0 ? 1 : 0
                nameNode.setNeedsLayout()
            })
            .disposed(by: self.disposeBag)
        
        let infoLayout = ASStackLayoutSpec(direction: .vertical,
                                           spacing: 10.0,
                                           justifyContent: .start,
                                           alignItems: .stretch,
                                           children: [regionNode,
                                                      nameNode])
        
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 10.0,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: [node,
                                                       infoLayout
        ])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 10.0,
                                                      left: 10.0,
                                                      bottom: 10.0,
                                                      right: 10.0),
                                 child: stackLayout)
    }
}

extension ExCellNode {
    static var titleAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.black,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)]
    }
    
    static var descAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.foregroundColor: UIColor.darkGray,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)]
    }
}
