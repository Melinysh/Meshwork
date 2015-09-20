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
import MultipeerConnectivity

class StatsViewController: UIViewController {
    
    let navigationItems = ["List", "Tree"]
	
	
	//set before transition
	var peers : [MCPeerID :ContactObject ]!
	var peerManager : MPCManager!
	
	let contactManager = ContactsManager()
	
	
	@IBOutlet weak var label3: UILabel!
	@IBOutlet weak var label2: UILabel!
	@IBOutlet weak var label1: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
		
		label1.text = "Total peers nearby: " + String(peers.count)
		label2.text = "Total known contacts nearby: " + String(Array(peers.values).filter { contactManager.doesHaveContactForName($0.name) }.count)
		
		
    }
	
	override func viewWillAppear(animated: Bool) {

		let menuView = BTNavigationDropdownMenu(title: "Stats", items: navigationItems)
		self.navigationItem.titleView = menuView
		self.navigationItem.hidesBackButton = true;

		menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
			print("Did select item at index: \(indexPath)")
			if indexPath == 0 {
				self.navigationController?.popToRootViewControllerAnimated(true)
			} else {
				let treeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("treeVC") as! NetworkBinaryTreeViewController
				treeVC.manager = self.peerManager
				treeVC.peers = self.peers
				self.navigationController?.pushViewController(treeVC, animated: true)
			}
		}

	}
	

}