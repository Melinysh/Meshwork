//
//  StatsViewController.swift
//  MeshWork
//
//  Created by galperin on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import Foundation
import UIKit

class StatsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutViews()
    }
    
    func layoutViews() {
        self.view.backgroundColor = UIColor.whiteColor()
        let label = UILabel(frame: CGRectMake(100, 100, 100, 20))
        label.text = "How are you"
        self.view.addSubview(label)
    }
}