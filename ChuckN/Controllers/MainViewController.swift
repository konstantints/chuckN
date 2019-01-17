//
//  MainViewController.swift
//  ChuckN
//
//  Created by Konstantin Tsistjakov on 17/01/2019.
//  Copyright © 2019 Chipp Studio. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.bool(forKey: "dark") {
            return .lightContent
        }
        
        return .default
    }
}
