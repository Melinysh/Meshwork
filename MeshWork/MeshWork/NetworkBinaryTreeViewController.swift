//
//  NetworkBinaryTreeDataSource.swift
//  Binary Tree
//
//  Created by Sam Haves on 2015-09-19.
//  Copyright (c) 2015 Sam Haves. All rights reserved.
//

import UIKit

class NetworkBinaryTreeViewController: UIViewController, NetworkBinaryTreeDataSource, MPCManagerDelegate {
    
    var manager : MPCManager! // must be set by another VC before transition
    let contactManager = ContactsManager()
    var peers = [MCPeerID : ContactObject]() {
        didSet {
            sortedPeers = Array(peers.values).sort { $0.0.name < $0.1.name }
        }
    }
    
    var sortedPeers = [ContactObject]() {
        didSet {
            deviceContacts = sortedPeers.filter{ contactManager.doesHaveContactForName($0.name) }
        }
    }
    
    var deviceContacts = [ContactObject]()
    
    @IBOutlet weak var treeView: NetworkBinaryTreeView! {
        didSet{
            treeView.dataSource = self
            treeView.addGestureRecognizer(UIPinchGestureRecognizer(target: treeView, action: "scale:"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self 
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        manager.delegate = self //MARK: - MPCManagerDelegate
        
        func lostPeer(peer: MCPeerID) {
            peers.removeValueForKey(peer)
            tableView.reloadData()
        }
        
        func receievedContactFromPeer(peer: MCPeerID, contact: ContactObject) {
            peers[peer] = contact
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contacts(sender: NetworkBinaryTreeView) -> [ContactObject] {
        return sortedPeers
    }
    
    func numberOfUsers(sender: NetworkBinaryTreeView) -> Int? {
        return 24
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
