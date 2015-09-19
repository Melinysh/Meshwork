//
//  ContactObject.swift
//  MeshWork
//
//  Created by Stephen Melinyshyn on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class ContactObject: NSObject, NSCoding {

  var photo : NSData?
  var name : String!
  var phoneNumber : String?
  var email : String?
  var twitter : String?
  var facebook : String?
  var github : String?
	
  @objc required init?(coder aDecoder: NSCoder) {
	super.init()
	photo = aDecoder.decodeObjectForKey("photo") as? NSData
    name = aDecoder.decodeObjectForKey("name") as? String
    phoneNumber = aDecoder.decodeObjectForKey("phoneNumber") as? String
    email = aDecoder.decodeObjectForKey("email") as? String
    twitter = aDecoder.decodeObjectForKey("twitter") as? String
    facebook = aDecoder.decodeObjectForKey("facebook") as? String
    github = aDecoder.decodeObjectForKey("github") as? String
  }

	override init() { super.init() }
  
    init(photo: NSData?, name: String!) {
        self.photo = photo
        self.name = name
    }
	
    
  @objc func encodeWithCoder(aCoder: NSCoder) {
	aCoder.encodeObject(photo, forKey: "photo")
    aCoder.encodeObject(name, forKey: "name")
    aCoder.encodeObject(phoneNumber, forKey: "phoneNumber")
    aCoder.encodeObject(email, forKey: "email")
    aCoder.encodeObject(twitter, forKey: "twitter")
    aCoder.encodeObject(facebook, forKey: "facebook")
    aCoder.encodeObject(github, forKey: "github")
  }
  
}
