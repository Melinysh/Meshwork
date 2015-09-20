//
//  DetailContactViewController.swift
//  MeshWork
//
//  Created by Stephen Melinyshyn on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class DetailContactViewController: UIViewController {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	
	var contact : ContactObject!
	let manager = ContactsManager()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if let pData = contact.photo {
			imageView.image = UIImage(data: pData)
			imageView.layer.cornerRadius = imageView.frame.height / 2
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
		manager.addContact(contact)
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
