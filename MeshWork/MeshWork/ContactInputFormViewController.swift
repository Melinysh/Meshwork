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

class ContactInputFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

	let firstName = ContactInputField()
	let lastName = ContactInputField()
	let email = ContactInputField()
	let phoneNumber = ContactInputField()
	let twitterHandle = ContactInputField()
	let githubHanlde = ContactInputField()
	
    
    var fieldsList = [UIView]()
    
	var beaneathVC : MainTableViewController! = MainTableViewController()
	
	
    @IBOutlet weak var cameraConstraint: NSLayoutConstraint!
    @IBOutlet weak var takePhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var takePhotoXConstraint: UIButton!
    @IBOutlet weak var cameraXConstraint: UIButton!
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
		
		cameraPicker.delegate = self
		cameraPicker.allowsEditing = true
		cameraPicker.sourceType = UIImagePickerControllerSourceType.Camera
        // Do any additional setup after loading the view.
		if UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front) {
			cameraPicker.delegate = self
			cameraPicker.allowsEditing = true
			cameraPicker.sourceType = UIImagePickerControllerSourceType.Camera
		} else {
			cameraButton.hidden = true
		}
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
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
        picker.dismissViewControllerAnimated(true, completion: {
            self.slideAwayToFields()
        })
	}
	
    func slideAwayToFields() {

        self.cameraConstraint.constant -= 500
        //self.takePhotoConstraint.constant -= 500
        self.takePhotoButton.setNeedsUpdateConstraints()
        self.cameraButton.setNeedsUpdateConstraints()
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping:
            0.6, initialSpringVelocity: 0.3, options:
            UIViewAnimationOptions.AllowAnimatedContent, animations: { () ->
                Void in
                //do actual move
                self.takePhotoButton.layoutIfNeeded()
                self.cameraButton.layoutIfNeeded()
            }, completion: { (complete) -> Void in
                //when animation completes, activate block if not nil
                if complete {
                    self.fadeInFields()
                }
        })
    }
    
    func fadeInFields() {
        
        let line = UIView()
        line.frame = CGRectMake(20, 130, self.view.bounds.width - 40, 1)
        line.backgroundColor = UIColor.blackColor()
        self.view.addSubview(line)
        
        fieldsList.append(line)
        
        let nameField = UITextField(frame: CGRectMake(20, 100, self.view.bounds.width - 40, 30))
        nameField.backgroundColor = UIColor.whiteColor()
        nameField.text = "Name"
        nameField.textColor = UIColor.lightGrayColor()
        self.view.addSubview(nameField)
        
        nameField.delegate = self
        
        fieldsList.append(nameField)
        
        let emailLine = UIView()
        emailLine.frame = CGRectMake(20, 175, self.view.bounds.width - 40, 1)
        emailLine.backgroundColor = UIColor.blackColor()
        self.view.addSubview(emailLine)
        
        fieldsList.append(emailLine)
        
        let emailField = UITextField(frame: CGRectMake(20, 145, self.view.bounds.width - 40, 30))
        emailField.backgroundColor = UIColor.whiteColor()
        emailField.text = "Email"
        emailField.textColor = UIColor.lightGrayColor()
        self.view.addSubview(emailField)
        
        emailField.delegate = self
        fieldsList.append(emailField)
        
        let phoneLine = UIView()
        phoneLine.frame = CGRectMake(20, 220, self.view.bounds.width - 40, 1)
        phoneLine.backgroundColor = UIColor.blackColor()
        self.view.addSubview(phoneLine)
        
        fieldsList.append(phoneLine)
        
        let phoneField = UITextField(frame: CGRectMake(20, 190, self.view.bounds.width - 40, 30))
        phoneField.backgroundColor = UIColor.whiteColor()
        phoneField.text = "Phone"
        phoneField.textColor = UIColor.lightGrayColor()
        self.view.addSubview(phoneField)
        
        phoneField.delegate = self
        fieldsList.append(phoneField)

        let facebookLine = UIView()
        facebookLine.frame = CGRectMake(20, 265, self.view.bounds.width - 40, 1)
        facebookLine.backgroundColor = UIColor.blackColor()
        self.view.addSubview(facebookLine)
        
        fieldsList.append(facebookLine)
        
        let facebookField = UITextField(frame: CGRectMake(20, 235, self.view.bounds.width - 40, 30))
        facebookField.backgroundColor = UIColor.whiteColor()
        facebookField.text = "Facebook"
        facebookField.textColor = UIColor.lightGrayColor()
        self.view.addSubview(facebookField)
        
        facebookField.delegate = self
        fieldsList.append(facebookField)
        
        let twitterLine = UIView()
        twitterLine.frame = CGRectMake(20, 310, self.view.bounds.width - 40, 1)
        twitterLine.backgroundColor = UIColor.blackColor()
        self.view.addSubview(twitterLine)
        
        fieldsList.append(twitterLine)
        
        let twitterField = UITextField(frame: CGRectMake(20, 280, self.view.bounds.width - 40, 30))
        twitterField.backgroundColor = UIColor.whiteColor()
        twitterField.text = "Twitter"
        twitterField.textColor = UIColor.lightGrayColor()
        self.view.addSubview(twitterField)
        
        twitterField.delegate = self
        fieldsList.append(twitterField)
        
        let githubLine = UIView()
        githubLine.frame = CGRectMake(20, 355, self.view.bounds.width - 40, 1)
        githubLine.backgroundColor = UIColor.blackColor()
        self.view.addSubview(githubLine)
        
        fieldsList.append(githubLine)
        
        let githubField = UITextField(frame: CGRectMake(20, 325, self.view.bounds.width - 40, 30))
        githubField.backgroundColor = UIColor.whiteColor()
        githubField.text = "GitHub"
        githubField.textColor = UIColor.lightGrayColor()
        self.view.addSubview(githubField)
        
        githubField.delegate = self
        fieldsList.append(githubField)
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
        for item in fieldsList {
            UIView.animateWithDuration(0.3, animations: {
                item.frame.origin.y -= 40
            })
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		
	}
	
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
