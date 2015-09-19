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
            
            let images: [UIImageView] = [twitterImage, facebookImage]
            
            if let c = contact {
                if let _ = c.twitter {
                    twitterImage.hidden = false
                }
                
                if let _ = c.facebook {
                    facebookImage.hidden = false
                }
                
                for (var x = 0; x < images.count; x++){
                    if images[x].hidden {
//                        for (var i = x; i < images.count; i++) {
//                            
//                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var twitterImage: UIImageView!
    @IBOutlet weak var facebookImage: UIImageView!
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

}
