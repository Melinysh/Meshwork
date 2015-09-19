//
//  ContactTableViewCell.swift
//  MeshWork
//
//  Created by Stephen Melinyshyn on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    var contact: ContactObject? {
        didSet{
            if let c = contact {
                if let _ = c.twitter {
                    twitterImage.hidden = false
                    let constraintImageWidth = NSLayoutConstraint (item: twitterImage,
                        attribute: NSLayoutAttribute.Width,
                        relatedBy: NSLayoutRelation.Equal,
                        toItem: nil,
                        attribute: NSLayoutAttribute.NotAnAttribute,
                        multiplier: 1,
                        constant: 24)
                    self.addConstraint(constraintImageWidth)
                }
                
                if let _ = c.facebook {
                    facebookImage.hidden = false
                }
                
                if let _ = c.linkedin {
                    linkedinImage.hidden = false
                }
                
                if let _ = c.github {
                    githubImage.hidden = false
                }
            }
        }
    }
    
    @IBOutlet weak var facebookConstraint: NSLayoutConstraint!
    @IBOutlet weak var facebookConstraintX: NSLayoutConstraint!
    @IBOutlet weak var linkedinConstraintX: NSLayoutConstraint!
    @IBOutlet weak var twitterImage: UIImageView!
    @IBOutlet weak var githubImageConstraintX: NSLayoutConstraint!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var linkedinImage: UIImageView!
    @IBOutlet weak var githubImage: UIImageView!
	@IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        if twitterImage.hidden {
            self.facebookConstraintX.constant -= 34
        }
        
        if facebookImage.hidden {
            self.linkedinConstraintX.constant -= 34
        }
        
        if linkedinImage.hidden {
            self.githubImageConstraintX.constant -= 34
        }
    }
}
