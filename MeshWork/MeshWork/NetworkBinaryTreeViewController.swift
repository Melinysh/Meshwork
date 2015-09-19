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
    
    var manager : MPCManager! // must be set by another VC before transition
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
			self.view = treeView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
		treeView = NetworkBinaryTreeView(contacts: [ContactObject](), peers: [ContactObject]())
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
        return  Array(deviceContacts)
    }
    
    func peers(sender: NetworkBinaryTreeView) -> [ContactObject] {
        return Array(sortedPeers)
    }
    
    //MARK: - MPCManagerDelegate
    
    func lostPeer(peer: MCPeerID) {
        peers.removeValueForKey(peer)
        //refresh drawing
        
    }
    
    func receievedContactFromPeer(peer: MCPeerID, contact: ContactObject) {
        peers[peer] = contact
        // refresh drawing
    }

}
