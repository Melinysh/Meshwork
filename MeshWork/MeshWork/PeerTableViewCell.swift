//
//  PeerTableViewCell.swift
//  MeshWork
//
//  Created by galperin on 2015-09-19.
//  Copyright © 2015 Stephen Melinyshyn. All rights reserved.
//

import Foundation
import UIKit

class PeerTableViewCell: UITableViewCell {
    
    let mainView = UIView()
    
    var contact: ContactObject? {
        didSet {
            let nameLabel = UILabel(frame: CGRectMake(10, 10, 100, 10))
            mainView.addSubview(nameLabel)
        }
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, contact: ContactObject!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contact = contact
        self.addSubview(mainView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}