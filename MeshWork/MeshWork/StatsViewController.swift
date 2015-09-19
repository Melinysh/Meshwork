//
//  StatsViewController.swift
//  MeshWork
//
//  Created by galperin on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import Foundation
import UIKit
import BTNavigationDropdownMenu

class StatsViewController: UIViewController {
    
    let navigationItems = ["Near Me", "Stats"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutViews()
        
        let menuView = BTNavigationDropdownMenu(title: navigationItems[1], items: navigationItems)
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            if indexPath == 0 {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func layoutViews() {
        self.view.backgroundColor = UIColor.whiteColor()
        let label = UILabel(frame: CGRectMake(100, 100, 100, 20))
        label.text = "How are you"
        self.view.addSubview(label)
    }
}