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
  func foundPeer()
  
  func lostPeer()
  
  func invitationWasReceived(fromPeer: String)
  
  func connectedWithPeer(peerID: MCPeerID)
  
  var browser : UIWebView! { get set }
  var lastRequest : NSURLRequest! { get set }
}

class MPCManager : NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate,  {
  
  var session : MCSession!
  let peer = MCPeerID(displayName: UIDevice.currentDevice().name)
  var browser : MCNearbyServiceBrowser!
  var advertiser: MCNearbyServiceAdvertiser!
  
  var foundPeer : (peer: MCPeerID?, info: [String : String]?)
  var invitationHandler : ((Bool, MCSession) -> Void)!
  
  var delegate : MPCManagerDelegate!
  
  init(delegate : MPCManagerDelegate) {
    super.init()
    
    self.delegate = delegate
    session = MCSession(peer: peer)
    session.delegate = self
    browser = MCNearbyServiceBrowser(peer: peer, serviceType: "meshwurk")
    browser.delegate = self
    advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: ["Test" : "This is a test that should be replaced"], serviceType: "meshwurk")
    advertiser.delegate = self
    
  }
  
  @objc func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    foundPeer = (peerID, info)
    delegate.foundPeer()
    
  }
  
  @objc func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    foundPeer = (nil, nil)
    delegate.lostPeer()
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
       
  }
  
  @objc func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
    switch state {
    case MCSessionState.Connected :
      print("Connected to session \(session)")
      delegate.connectedWithPeer(peerID)
      
    case MCSessionState.Connecting :
      print("Connecting to session \(session)")
      
    default:
      print("Did not connect to session \(session)")
    }
  }


}