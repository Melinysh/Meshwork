//
//  ContactInputFormViewController.swift
//  MeshWork
//
//  Created by Stephen Melinyshyn on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class ContactInputField: UITextField {
	var associatedLine: UIView?
	var placeholderText: String?
}

class ContactInputFormViewController: UIViewController, UIImagePickerControllerDelegate {

	let firstName = ContactInputField()
	let lastName = ContactInputField()
	let email = ContactInputField()
	let phoneNumber = ContactInputField()
	let twitterHandle = ContactInputField()
	let githubHanlde = ContactInputField()
	
	let photoPicker = UIImagePickerController()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		photoPicker.delegate = self
		photoPicker.allowsEditing = false
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
	
	}
	
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		
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
