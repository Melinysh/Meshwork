//
//  MainTableViewController.swift
//  MeshWork
//
//  Created by galperin on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
import BTNavigationDropdownMenu

class MainTableViewController: UITableViewController, MPCManagerDelegate {
	
    let navigationItems = ["Network Graph", "Stats"]
	var selfContact : ContactObject! = nil {
		didSet {
			if NSUserDefaults.standardUserDefaults().objectForKey("selfContact") == nil {
				NSUserDefaults.standardUserDefaults().setObject(NSKeyedArchiver.archivedDataWithRootObject(selfContact), forKey: "selfContact")
				NSUserDefaults.standardUserDefaults().synchronize()
			}
		}
	}
	let contactManager = ContactsManager()
	var peerManager : MPCManager!
	var peers = [MCPeerID : ContactObject]() {
		didSet {
			sortedPeers = Array(peers.values).sort { $0.0.name < $0.1.name }
		}
	}
	
	var sortedPeers = [ContactObject]()

	
	@IBAction func massAdd(sender: AnyObject) {
		
		for c in sortedPeers {
			contactManager.addContact(c)
		}
		
		let imageV = UIImageView(image: UIImage(named: "addedAll.png")!)
		imageV.center = view.center
		imageV.alpha = 0
		view.addSubview(imageV)
		UIView.animateWithDuration(1.0, animations: { () -> Void in
			imageV.alpha = 1
			}) { (isFinished) -> Void in
				UIView.animateWithDuration(0.7, delay: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
					imageV.alpha = 0
					}, completion: { (fin) -> Void in
						imageV.removeFromSuperview()
				})
		}
		
	}
	override func viewDidLoad() {
        super.viewDidLoad()
		
		if let contactData = NSUserDefaults.standardUserDefaults().dataForKey("selfContact") {
			selfContact = NSKeyedUnarchiver.unarchiveObjectWithData(contactData) as! ContactObject

        }
        
		
        
		if selfContact == nil {
			let inputForm = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("inputVC") as! ContactInputFormViewController
			inputForm.beaneathVC = self 
			presentViewController(inputForm, animated: true, completion: nil)
			return
		} else {
			peerManager = MPCManager(delegate: self, selfContact: selfContact)
			peerManager.advertiser.startAdvertisingPeer()
			peerManager.browser.startBrowsingForPeers()
		}
        
        peerManager = MPCManager(delegate: self, selfContact: selfContact)
        peerManager.advertiser.startAdvertisingPeer()
        peerManager.browser.startBrowsingForPeers()
    }
    override func viewDidAppear(animated: Bool) {
		if selfContact != nil {
			if peerManager == nil {
				peerManager = MPCManager(delegate: self, selfContact: selfContact)
				peerManager.advertiser.startAdvertisingPeer()
				peerManager.browser.startBrowsingForPeers()
			}
			peerManager.delegate = self
		}
    }
	
    override func viewWillAppear(animated: Bool) {
		let menuView = BTNavigationDropdownMenu(title: "Nearby", items: navigationItems)
		self.navigationItem.titleView = menuView
		self.navigationItem.hidesBackButton = true;
		menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
			print("Did select item at index: \(indexPath)")
			if indexPath == 1 {
				let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("statsVC") as! StatsViewController
				vc.peers = self.peers
				vc.peerManager = self.peerManager
				self.navigationController?.pushViewController(vc, animated: true)
			} else {
				let treeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("treeVC") as! NetworkBinaryTreeViewController
				treeVC.manager = self.peerManager
				treeVC.peers = self.peers
				self.navigationController?.pushViewController(treeVC, animated: true)
			}
		}
    }
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ContactTableViewCell

        let contact: ContactObject = sortedPeers[indexPath.row]
        cell.contact = contact
        cell.nameLabel?.text = contact.name
		if let photoData = contact.photo {
			cell.photo.image = UIImage(data: photoData)
			cell.photo.layer.cornerRadius = 35 
		}
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPeers.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
		
		let contact = sortedPeers[indexPath.row]
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("detailVC") as! DetailContactViewController
		detailVC.contact = contact
		self.navigationController?.pushViewController(detailVC, animated: true)
		
    }
	
	//MARK: - MPCManagerDelegate
	
	func lostPeer(peer: MCPeerID) {
		peers.removeValueForKey(peer)
		NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
			self.tableView.reloadData()
		}
	}
	
	func receievedContactFromPeer(peer: MCPeerID, contact: ContactObject) {
		peers[peer] = contact
		NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
			self.tableView.reloadData()
		}
	}
	
	
}
