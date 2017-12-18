//
//  facultyCell.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/9/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    @IBOutlet weak var imagePic: UIImageView!
    @IBOutlet weak var senderName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(name: String){
        senderName.text = name
        
        if name == "MCIS Chat"{
            imagePic.image = #imageLiteral(resourceName: "crest")
        }else{
            imagePic.image = #imageLiteral(resourceName: "profilePic")
        }
    }
}
