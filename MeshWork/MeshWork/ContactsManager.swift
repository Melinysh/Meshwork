//
//  ContactsManager.swift
//  MeshWork
//
//  Created by Stephen Melinyshyn on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import Contacts


class ContactsManager {
	let store = CNContactStore()
	
	func addContact(contact : ContactObject) {
		let newContact = CNMutableContact()
		newContact.imageData = contact.photo
		newContact.givenName = contact.name.componentsSeparatedByString(" ").first ?? contact.name
		newContact.familyName = contact.name.componentsSeparatedByString(" ").last ?? ""
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
	
	func doesHaveContactForName(fullName : String) -> Bool {
		let pred = CNContact.predicateForContactsMatchingName(fullName)
		do {
			let contacts = try store.unifiedContactsMatchingPredicate(pred, keysToFetch: [])
			if contacts.count > 0 {
				return true
			}
		} catch {
			print("There was an error fetching from the contact store \(error)")
		}
		return false
	}
	
	
}
