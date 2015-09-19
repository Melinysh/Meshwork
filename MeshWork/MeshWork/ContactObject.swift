//
//  ContactObject.swift
//  MeshWork
//
//  Created by Stephen Melinyshyn on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class ContactObject: NSObject, NSCoding {

  var photo : UIImage?
  var name : String!
  var phoneNumber : String?
  var email : String?
  var twitter : String?
  var facebook : String?
  var github : String?
  var linkedin : String?
  
  required init?(coder aDecoder: NSCoder) {
    photo = aDecoder.decodeObjectForKey("photo") as? UIImage
    name = aDecoder.decodeObjectForKey("name") as? String
    phoneNumber = aDecoder.decodeObjectForKey("phoneNumber") as? String
    email = aDecoder.decodeObjectForKey("email") as? String
    twitter = aDecoder.decodeObjectForKey("twitter") as? String
    facebook = aDecoder.decodeObjectForKey("facebook") as? String
    github = aDecoder.decodeObjectForKey("github") as? String
    linkedin = aDecoder.decodeObjectForKey("linkedin") as? String
  }
	
	override init() {
		super.init()
	}
  
    init(photo: UIImage?, name: String!) {
        super.init()
        self.photo = photo
        self.name = name
    }
    
  func encodeWithCoder(aCoder: NSCoder) {
	super.description
    aCoder.encodeObject(photo, forKey: "photo")
    aCoder.encodeObject(name, forKey: "name")
    aCoder.encodeObject(phoneNumber, forKey: "phoneNumber")
    aCoder.encodeObject(email, forKey: "email")
    aCoder.encodeObject(twitter, forKey: "twitter")
    aCoder.encodeObject(facebook, forKey: "facebook")
    aCoder.encodeObject(github, forKey: "github")
    aCoder.encodeObject(linkedin, forKey: "linkedin")
  }
  
}
