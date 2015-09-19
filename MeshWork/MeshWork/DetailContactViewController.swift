//
//  DetailContactViewController.swift
//  MeshWork
//
//  Created by Stephen Melinyshyn on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import Contacts

class DetailContactViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	
	var contact : ContactObject!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if let pData = contact.photo {
			imageView.image = UIImage(data: pData)
		}
		nameLabel.text = contact.name
		emailLabel.text = contact.email
		phoneLabel.text = contact.phoneNumber
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func addToContacts(sender: AnyObject) {
		
		let store = CNContactStore()
		let newContact = CNMutableContact()
		newContact.imageData = contact.photo
		newContact.givenName = contact.name.componentsSeparatedByString(" ").first!
		newContact.familyName = contact.name.componentsSeparatedByString(" ").last!
		if let phoneNumber = contact.phoneNumber {
			newContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: phoneNumber))]
		}
		if let emailAddr = contact.email {
			newContact.emailAddresses = [CNLabeledValue(label: CNLabelEmailiCloud, value: emailAddr)]
		}
		
		var socialProfiles = [CNLabeledValue]()
		if let twitter = contact.twitter {
			socialProfiles.append( CNLabeledValue(label: CNSocialProfileServiceTwitter, value: CNSocialProfile(urlString: "http://twitter.com", username: twitter, userIdentifier: nil, service: "Twitter")))
		}
		if let facebook = contact.facebook {
			socialProfiles.append( CNLabeledValue(label: CNSocialProfileServiceFacebook, value: CNSocialProfile(urlString: "http://facebook.com", username: nil, userIdentifier: facebook, service: "Facebook")))
		}
		if let github = contact.github {
			socialProfiles.append( CNLabeledValue(label: CNSocialProfileServiceKey, value: CNSocialProfile(urlString: "http://github.com", username: github, userIdentifier: nil, service: "GitHub")))
		}
		newContact.socialProfiles = socialProfiles
		
		let saveReq = CNSaveRequest()
		saveReq.addContact(newContact, toContainerWithIdentifier: nil)
		do {
			try store.executeSaveRequest(saveReq)
		} catch {
			print("There was an error adding the new contact \(error)")
		}
		
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
