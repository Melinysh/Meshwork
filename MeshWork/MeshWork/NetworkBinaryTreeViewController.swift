//
//  NetworkBinaryTreeDataSource.swift
//  Binary Tree
//
//  Created by Sam Haves on 2015-09-19.
//  Copyright (c) 2015 Sam Haves. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class NetworkBinaryTreeViewController: UIViewController, NetworkBinaryTreeDataSource, MPCManagerDelegate {
    // must be set by another VC before transition
    var manager : MPCManager!
	
    let contactManager = ContactsManager()
    var peers = [MCPeerID : ContactObject]() {
        didSet {
            sortedPeers = Set<ContactObject>(peers.values)
        }
    }
    
    var sortedPeers = Set<ContactObject>() {
        didSet {
            deviceContacts = Set<ContactObject>(Array(sortedPeers).filter{ contactManager.doesHaveContactForName($0.name) })
			sortedPeers = sortedPeers.subtract(deviceContacts)
        }
    }
    
    var deviceContacts = Set<ContactObject>()
    
    @IBOutlet weak var treeView: NetworkBinaryTreeView! {
        didSet{
            treeView.dataSource = self
			treeView.frame = view.frame
			treeView.controller = self
			self.view = treeView
        }
    }
	
	func didTapNode(sender : UITapGestureRecognizer) {
		guard let node = sender.view as? ContactImageNode else {
			print("What did I just tap on? Error.")
			return
		}
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("detailVC") as! DetailContactViewController
		detailVC.contact = node.contact
		self.navigationController?.pushViewController(detailVC, animated: true)
		
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
		treeView = NetworkBinaryTreeView(contacts: Array(deviceContacts) , peers: Array(sortedPeers))
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        manager.delegate = self //MARK: - MPCManagerDelegate
        
        func lostPeer(peer: MCPeerID) {
            peers.removeValueForKey(peer)
        }
        
        func receievedContactFromPeer(peer: MCPeerID, contact: ContactObject) {
            peers[peer] = contact
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contacts(sender: NetworkBinaryTreeView) -> [ContactObject] {
        return Array(deviceContacts)
    }
    
    func peers(sender: NetworkBinaryTreeView) -> [ContactObject] {
        return Array(sortedPeers)
    }
    
    //MARK: - MPCManagerDelegate
    
    func lostPeer(peer: MCPeerID) {
        peers.removeValueForKey(peer)
        treeView.setNeedsDisplay()
        
    }
    
    func receievedContactFromPeer(peer: MCPeerID, contact: ContactObject) {
        peers[peer] = contact
        treeView.setNeedsDisplay()
    }

}
