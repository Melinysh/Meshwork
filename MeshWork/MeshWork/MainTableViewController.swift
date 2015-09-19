//
//  MainTableViewController.swift
//  MeshWork
//
//  Created by galperin on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import Foundation
import UIKit

class MainTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let contact: ContactObject = ContactObject(photo: nil, name: "test")
        
        cell.textLabel?.text = contact.name
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}