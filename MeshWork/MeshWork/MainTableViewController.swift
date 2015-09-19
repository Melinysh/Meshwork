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
	
    let navigationItems = ["Near Me", "Stats"]
    
	var c : ContactObject = {
		let contact = ContactObject()
		contact.name = "Sam Haves"
		contact.email = "shaves@uwaterloo.ca" // <- hit me up ladies
		contact.phoneNumber = "101-1010-10101"
		contact.twitter = "Shaves"
		contact.photo = UIImagePNGRepresentation(UIImage(named: "stevo.png")!)
		return contact
	}()
	
	var c2 : ContactObject = {
		let contact = ContactObject()
		contact.name = "Stephen Melinyshyn"
		contact.email = "smmeliny@uwaterloo.ca" // <- hit me up ladies
		contact.phoneNumber = "420-8008-6969"
		contact.twitter = "Shaves"
        contact.github = "Shaves"
		contact.photo = UIImagePNGRepresentation(UIImage(named: "stevo.png")!)
		return contact
    }()
	
	var peerManager : MPCManager!
	var peers = [MCPeerID : ContactObject]() {
		didSet {
			sortedPeers = Array(peers.values).sort { $0.0.name < $0.1.name }
		}
	}
	
	var sortedPeers = [ContactObject]()

	
	override func viewDidLoad() {
        super.viewDidLoad()
		peerManager = MPCManager(delegate: self, selfContact: UIDevice().name == "iPhone" ? c : c2) //changed to make testing easier
		peerManager.advertiser.startAdvertisingPeer()
		peerManager.browser.startBrowsingForPeers()
        
        let menuView = BTNavigationDropdownMenu(title: navigationItems.first!, items: navigationItems)
        self.navigationItem.titleView = menuView
        
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            print("Did select item at index: \(indexPath)")
            if indexPath == 1 {
                let vc = StatsViewController()
                let nv = UINavigationController(rootViewController: vc)
                self.presentViewController(nv, animated: true, completion: nil)
            }
            //self.selectedCellLabel.text = navigationItems[indexPath]
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ContactTableViewCell

        let contact: ContactObject = c2//sortedPeers[indexPath.row]
        cell.contact = contact
        cell.nameLabel?.text = contact.name
		if let photoData = contact.photo {
			cell.photo.image = UIImage(data: photoData)
		}
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPeers.count + 1
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
		tableView.reloadData()
	}
	
	func receievedContactFromPeer(peer: MCPeerID, contact: ContactObject) {
		peers[peer] = contact
		tableView.reloadData()
	}
	
	
}
