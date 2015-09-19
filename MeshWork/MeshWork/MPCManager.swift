//
//  MPCManager.swift
//  MeshWork
//
//  Created by Stephen Melinyshyn on 2015-09-18.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol MPCManagerDelegate {
	func foundPeer(peer : MCPeerID)
	func lostPeer(peer : MCPeerID)
	func invitationWasReceived(fromPeer: String)
	func receievedContactFromPeer(peer : MCPeerID, contact : ContactObject)
}

class MPCManager : NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate  {
  
  var session : MCSession!
  let selfPeer = MCPeerID(displayName: UIDevice.currentDevice().name)
  var selfContact : ContactObject!
  var browser : MCNearbyServiceBrowser!
  var advertiser: MCNearbyServiceAdvertiser!
  
  var foundPeers : [String : MCPeerID] = [String : MCPeerID]()
  var invitationHandler : ((Bool, MCSession) -> Void)!
  
  var delegate : MPCManagerDelegate!
  
  init(delegate : MPCManagerDelegate, selfContact : ContactObject) {
    super.init()
    
    self.delegate = delegate
    self.selfContact = selfContact
    session = MCSession(peer: selfPeer)
    session.delegate = self
    browser = MCNearbyServiceBrowser(peer: selfPeer, serviceType: "meshwurk")
    browser.delegate = self
    advertiser = MCNearbyServiceAdvertiser(peer: selfPeer, discoveryInfo: nil, serviceType: "meshwurk")
    advertiser.delegate = self
    
  }
  
  @objc func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    foundPeers[peerID.displayName] = peerID
  }
  
  @objc func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    foundPeers.removeValueForKey(peerID.displayName)
    delegate.lostPeer(peerID)
  }
  
  @objc func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
    fatalError(error.description)
  }
  
  
  @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
    self.invitationHandler = invitationHandler
    delegate.invitationWasReceived(peerID.displayName)
  }
  
  @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
    fatalError(error.description)
  }
  
  @objc func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
    
  }
  
  @objc func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
  }
  
  @objc func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
  }
  
  @objc func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
    certificateHandler(true)
  }
  
  @objc func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
    guard let contact = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ContactObject else {
		print("Looks like the recieved object is not a contact :(.")
		return
    }
	delegate.receievedContactFromPeer(peerID, contact: contact)
	
  }
  
  @objc func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    switch state {
        case MCSessionState.Connected :
        print("Connected to session \(session)")
        do {
            try session.sendData(NSKeyedArchiver.archivedDataWithRootObject(selfContact), toPeers: [peerID], withMode: .Reliable)
        } catch {
            print("Error sending over contact \(error)")
        }

        case MCSessionState.Connecting :
        print("Connecting to session \(session)")

        default:
        print("Did not connect to session \(session)")
    }
  }


}