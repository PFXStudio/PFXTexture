//
//  ListView.swift
//  PFXTexture
//
//  Created by jinwoo.park on 2020/07/23.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import Foundation
import AsyncDisplayKit

class ListViewController: ASDKViewController<ASTableNode> {
    enum Item: Int, CaseIterable {
        case table
        case collection
        
        var title: String {
            switch self {
            case .table: return "ASTableNode Example"
            case .collection: return "ASCollectionNode Example"
            }
        }
    }
    
    override init() {
        super.init(node: ASTableNode())
        node.delegate = self
        node.dataSource = self
        title = "Categories"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.view.alwaysBounceVertical = true
    }
}

extension ListViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return Item.allCases.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        guard let item = Item(rawValue: indexPath.row) else { return ASCellNode() }
        let cell = ASTextCellNode()
        cell.selectionStyle = .none
        cell.text = item.title
        return cell
    }
}


extension ListViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    }
}
