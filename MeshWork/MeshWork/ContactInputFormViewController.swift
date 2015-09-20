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

    let nameField = UITextField()
    let emailField = UITextField()
    let phoneField = UITextField()
    let twitterField = UITextField()
    let facebookField = UITextField()
    let githubField = UITextField()
    

	
    
    var fieldsList = [UIView]()
    
	var beaneathVC : MainTableViewController! = MainTableViewController()
	
	
    @IBOutlet weak var cameraConstraint: NSLayoutConstraint!
    @IBOutlet weak var takePhotoConstraint: NSLayoutConstraint!
    @IBOutlet weak var takePhotoXConstraint: UIButton!
    @IBOutlet weak var cameraXConstraint: UIButton!
	@IBOutlet weak var userPhoto: UIImageView!
	@IBOutlet weak var doneButton: UIButton!
	
	@IBOutlet weak var choosePhotoButton: UIButton!

	let photoPicker = UIImagePickerController()
	let cameraPicker = UIImagePickerController()
	
	@IBOutlet weak var cameraButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
		photoPicker.delegate = self
		photoPicker.allowsEditing = true
		photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		
		
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
        
        nameField.delegate = self
        emailField.delegate = self
        phoneField.delegate = self
        twitterField.delegate = self
        facebookField.delegate = self
        githubField.delegate = self
		
		doneButton.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func doneInputForm(sender: AnyObject) {
		let contact = ContactObject()
		contact.name =  nameField.text
		contact.email = emailField.text
		contact.phoneNumber = phoneField.text
		contact.twitter = twitterField.text
		contact.github = githubField.text
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
        self.choosePhotoButton.setNeedsUpdateConstraints()
        self.cameraButton.setNeedsUpdateConstraints()
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping:
            0.6, initialSpringVelocity: 0.3, options:
            UIViewAnimationOptions.AllowAnimatedContent, animations: { () ->
                Void in
                //do actual move
                self.choosePhotoButton.layoutIfNeeded()
                self.cameraButton.layoutIfNeeded()
            }, completion: { (complete) -> Void in
                //when animation completes, activate block if not nil
                if complete {
                    self.fadeInFields()
                }
				self.userPhoto.removeFromSuperview()
				self.cameraButton.removeFromSuperview()
				self.choosePhotoButton.removeFromSuperview()
				
				for v in self.view.subviews {
					if v is UILabel {
						if (v as! UILabel).text != nil {
							continue
						}
					} else if v is UIButton {
						continue
					}
					UIView.animateWithDuration(0.1, animations: { () -> Void in
						v.alpha = 1
					})
					
				}
        })
    }
    
    func fadeInFields() {
        
        let line = UIView()
        line.frame = CGRectMake(20, 130, self.view.bounds.width - 40, 1)
        line.backgroundColor = UIColor.blackColor()
        self.view.addSubview(line)
        line.alpha = 0
        fieldsList.append(line)
        
        nameField.frame =  CGRectMake(20, 100, self.view.bounds.width - 40, 30)
		nameField.backgroundColor = self.view.backgroundColor //  self.view.backgroundColor // UIColor.whiteColor()
        nameField.attributedPlaceholder = NSAttributedString(string:"Name",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        nameField.textColor = UIColor.lightGrayColor()
		nameField.alpha = 0
        self.view.addSubview(nameField)
        
        fieldsList.append(nameField)
        
        let emailLine = UIView()
        emailLine.frame = CGRectMake(20, 175, self.view.bounds.width - 40, 1)
        emailLine.backgroundColor = UIColor.blackColor()
		emailLine.alpha = 0
        self.view.addSubview(emailLine)
        
        fieldsList.append(emailLine)
        
        emailField.frame = CGRectMake(20, 145, self.view.bounds.width - 40, 30)
        emailField.backgroundColor =  self.view.backgroundColor //  self.view.backgroundColor // UIColor.whiteColor()
        emailField.attributedPlaceholder = NSAttributedString(string:"Email",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        emailField.textColor = UIColor.lightGrayColor()
		emailField.alpha = 0
        self.view.addSubview(emailField)
        
        fieldsList.append(emailField)
        
        let phoneLine = UIView()
        phoneLine.frame = CGRectMake(20, 220, self.view.bounds.width - 40, 1)
        phoneLine.backgroundColor = UIColor.blackColor()
		phoneLine.alpha = 0
        self.view.addSubview(phoneLine)
        
        fieldsList.append(phoneLine)
        
        phoneField.frame = CGRectMake(20, 190, self.view.bounds.width - 40, 30)
        phoneField.backgroundColor =  self.view.backgroundColor // UIColor.whiteColor()
        phoneField.attributedPlaceholder = NSAttributedString(string:"Phone",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        phoneField.textColor = UIColor.lightGrayColor()
		phoneField.keyboardType = UIKeyboardType.PhonePad
		phoneField.alpha = 0
        self.view.addSubview(phoneField)
        
        fieldsList.append(phoneField)

        let facebookLine = UIView()
        facebookLine.frame = CGRectMake(20, 265, self.view.bounds.width - 40, 1)
        facebookLine.backgroundColor = UIColor.blackColor()
		facebookLine.alpha = 0
        self.view.addSubview(facebookLine)
        
        fieldsList.append(facebookLine)
        
        facebookField.frame = CGRectMake(20, 235, self.view.bounds.width - 40, 30)
        facebookField.backgroundColor =  self.view.backgroundColor // UIColor.whiteColor()
        facebookField.attributedPlaceholder = NSAttributedString(string:"Facebook",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        facebookField.textColor = UIColor.lightGrayColor()
		facebookField.alpha = 0
        self.view.addSubview(facebookField)
        
        fieldsList.append(facebookField)
        
        let twitterLine = UIView()
        twitterLine.frame = CGRectMake(20, 310, self.view.bounds.width - 40, 1)
        twitterLine.backgroundColor = UIColor.blackColor()
		twitterLine.alpha = 0
        self.view.addSubview(twitterLine)
        
        fieldsList.append(twitterLine)
        
        twitterField.frame = CGRectMake(20, 280, self.view.bounds.width - 40, 30)
        twitterField.backgroundColor =  self.view.backgroundColor // UIColor.whiteColor()
        twitterField.attributedPlaceholder = NSAttributedString(string:"Twitter",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        twitterField.textColor = UIColor.lightGrayColor()
		twitterField.alpha = 0
        self.view.addSubview(twitterField)
        
        fieldsList.append(twitterField)
        
        let githubLine = UIView()
        githubLine.frame = CGRectMake(20, 355, self.view.bounds.width - 40, 1)
        githubLine.backgroundColor = UIColor.blackColor()
		githubLine.alpha = 0
        self.view.addSubview(githubLine)
        
        fieldsList.append(githubLine)
        
        githubField.frame = CGRectMake(20, 325, self.view.bounds.width - 40, 30)
        githubField.backgroundColor =  self.view.backgroundColor // UIColor.whiteColor()
        githubField.attributedPlaceholder = NSAttributedString(string:"GitHub",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        githubField.textColor = UIColor.lightGrayColor()
		githubLine.alpha = 0
        self.view.addSubview(githubField)
        
        fieldsList.append(githubField)
		
		
		
		for v in self.view.subviews.reverse() {
			if v is UILabel {
				if (v as! UILabel).text != nil {
					continue
				}
			} else if v is UIButton {
				continue
			}
			UIView.animateWithDuration(1.0, animations: { () -> Void in
				v.alpha = 1
			})
			
		}
    }
	
    func textFieldDidBeginEditing(textField: UITextField) {    //delegate method
            for item in fieldsList {
                UIView.animateWithDuration(0.3, animations: {
                    item.frame.origin.y -= 40
                })
           }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {  //delegate method
     
        for item in fieldsList {
            UIView.animateWithDuration(0.3, animations: {
                item.frame.origin.y += 40
            })
        }
		if let text = nameField.text {
			if text.characters.count > 1 {
				doneButton.alpha = 1
			} else {
				doneButton.alpha = 0
			}
		} else {
			doneButton.alpha = 0
		}
		
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
	func imagePickerControllerDidCancel(picker: UIImagePickerController) {
		picker.dismissViewControllerAnimated(true, completion: nil)
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
