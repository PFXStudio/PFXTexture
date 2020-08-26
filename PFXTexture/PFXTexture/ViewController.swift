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
        guard let destination = UIStoryboard(name: "DynamicScene", bundle: nil).instantiateViewController(withIdentifier: String(describing: DynamicSceneViewController.self)) as? DynamicSceneViewController else { return }
        destination.modalPresentationStyle = .fullScreen
        self.present(destination, animated: true, completion: nil)
    }
}

