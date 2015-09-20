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

	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	
	var contact : ContactObject!
	let manager = ContactsManager()

	@IBOutlet weak var gitHubButton: UIButton!
	@IBOutlet weak var twitterButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
		if let pData = contact.photo {
			imageView.image = UIImage(data: pData)
			imageView.layer.cornerRadius = imageView.frame.height / 2
		}
		nameLabel.text = contact.name
		emailLabel.text = contact.email
		phoneLabel.text = contact.phoneNumber
		
		if contact.twitter == nil {
			twitterButton.removeFromSuperview()
		}
		if contact.github == nil {
			gitHubButton.removeFromSuperview()
		}
		if contact.phoneNumber == nil {
			phoneLabel.removeFromSuperview()
		}
		
		if contact.email == nil {
			emailLabel.removeFromSuperview()
		}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	@IBAction func toTwitter(sender: AnyObject) {
		UIApplication.sharedApplication().openURL(NSURL(string: "twitter://user?screen_name=" + contact.twitter!)!)
	}
	
	@IBAction func toGitHub(sender: AnyObject) {
		UIApplication.sharedApplication().openURL(NSURL(string: "https://github.com/" + contact.github!)!)
	}
	@IBAction func addToContacts(sender: AnyObject) {
		manager.addContact(contact)
		
		let imageV = UIImageView(image: UIImage(named: "addedContacts.png")!)
		imageV.center = view.center
		imageV.alpha = 0
		view.addSubview(imageV)
		UIView.animateWithDuration(1.0, animations: { () -> Void in
			imageV.alpha = 1
			}) { (isFinished) -> Void in
				UIView.animateWithDuration(0.7, delay: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
					imageV.alpha = 0
					}, completion: { (fin) -> Void in
						imageV.removeFromSuperview()
				})
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
