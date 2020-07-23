//
//  MainViewController.swift
//  PFXTexture
//
//  Created by jinwoo.park on 2020/07/23.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import UIKit
import TextureSwiftSupport

class MainViewController: PlainDisplayNodeViewController {
    private let topLabelNode = ASTextNode()
    private let buttonNode = ASButtonNode()

    override init() {
        super.init()
        view.backgroundColor = .white
        topLabelNode.attributedText = .init(string: "Attatched on safe-area")
        buttonNode.cornerRoundingType = .clipping
        buttonNode.titleNode.attributedText = .init(string: "Confirm")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
      LayoutSpec {
        
        ZStackLayout {
            topLabelNode
              .padding(UIEdgeInsets(top: 20, left: 20, bottom: .infinity, right: .infinity))

          CenterLayout {
            VStackLayout {
                buttonNode
            }
          }
        }
        .padding(capturedSafeAreaInsets)
      }
    }
}

