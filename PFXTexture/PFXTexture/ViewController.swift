//
//  ViewController.swift
//  PFXTexture
//
//  Created by jinwoo.park on 2020/07/23.
//  Copyright © 2020 jinwoo.park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func touchedStartButton(_ sender: Any) {
        let controller = RepositoryViewController()
        controller.viewModel = RepositoryViewModel(dependency: RepositoryViewModel.Dependency())
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: false, completion: nil)
    }
}

