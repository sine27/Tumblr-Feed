//
//  PhotoCell.swift
//  Tumblr Feed
//
//  Created by Shayin Feng on 2/1/17.
//  Copyright © 2017 Shayin Feng. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var userhead: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userhead.layer.masksToBounds = true
        userhead.layer.cornerRadius = userhead.frame.width / 2
        userhead.layer.borderWidth = 3
        userhead.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
