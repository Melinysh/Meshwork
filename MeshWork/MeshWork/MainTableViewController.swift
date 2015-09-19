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

class MainTableViewController: UITableViewController, MPCManagerDelegate {
	
	var c : ContactObject = {
		let contact = ContactObject()
		contact.name = "Sam Haves"
		contact.email = "shaves@uwaterloo.ca" // <- hit me up ladies
		contact.phoneNumber = "101-1010-10101"
		contact.twitter = "Shaves"
		contact.photo = UIImage(named: "stevo.png")
		return contact
	}()
	
	var c2 : ContactObject = {
		let contact = ContactObject()
		contact.name = "Stephen Melinyshyn"
		contact.email = "smmeliny@uwaterloo.ca" // <- hit me up ladies
		contact.phoneNumber = "420-8008-6969"
		contact.twitter = "Shaves"
		contact.photo = UIImage(named: "stevo.png")
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
		peerManager = MPCManager(delegate: self, selfContact: c2)
		peerManager.advertiser.startAdvertisingPeer()
		peerManager.browser.startBrowsingForPeers()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ContactTableViewCell

        let contact: ContactObject = ContactObject(photo: UIImage(named: "stevo.png"), name: "Stevo 'The Steve' Steve")//sortedPeers[indexPath.row]
        contact.twitter = "Bless"
        contact.facebook = "Jonathan Galperin"
        contact.linkedin = "sweg"
        contact.github = "yey"
        cell.contact = contact
        cell.nameLabel?.text = contact.name
		cell.photo.image = contact.photo
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