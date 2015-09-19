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

class ContactInputFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	let firstName = ContactInputField()
	let lastName = ContactInputField()
	let email = ContactInputField()
	let phoneNumber = ContactInputField()
	let twitterHandle = ContactInputField()
	let githubHanlde = ContactInputField()
	
	var beaneathVC : MainTableViewController! = MainTableViewController()
	
	
	@IBOutlet weak var takePhotoButton: UIButton!
	@IBOutlet weak var userPhoto: UIImageView!
	@IBOutlet weak var doneButton: UIButton!
	
	@IBOutlet weak var cameraButton: UIButton!
	let photoPicker = UIImagePickerController()
	let cameraPicker = UIImagePickerController()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		photoPicker.delegate = self
		photoPicker.allowsEditing = true
		photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		
		if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front) {
			cameraPicker.delegate = self
			cameraPicker.allowsEditing = true
			cameraPicker.sourceType = UIImagePickerControllerSourceType.Camera
		} else {
			cameraButton.hidden = true
		}
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func doneInputForm(sender: AnyObject) {
		let contact = ContactObject()
		contact.name = firstName.text! + " " + lastName.text!
		contact.email = email.text
		contact.phoneNumber = phoneNumber.text
		contact.twitter = twitterHandle.text
		contact.github = githubHanlde.text
		if let photo = userPhoto.image {
			contact.photo = UIImagePNGRepresentation(photo)
		}
		beaneathVC.selfContact = contact
		dismissViewControllerAnimated(true, completion: nil)
	
	}
	@IBAction func takePhoto(sender: AnyObject) {
		presentViewController(cameraPicker, animated: true, completion: nil)
	}
	
	@IBAction func choosePhoto(sender: AnyObject) {
		presentViewController(photoPicker, animated: true, completion: nil)
		
	}
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		userPhoto.image = image
		picker.dismissViewControllerAnimated(true, completion: nil)
		
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
