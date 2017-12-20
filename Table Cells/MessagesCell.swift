//
//  facultyCell.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/9/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit

class MessagesCell: UITableViewCell {
    
    var cellUser: user!

    @IBOutlet weak var pic: UIImageView!
    @IBOutlet weak var sendName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(user: user){
        cellUser = user
        let name = user._fname + " " + user._lname
        sendName.text = name
        
        let initialImageView = InitialImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        if user._faculty == "True"{
            initialImageView.setImageWithName(name: name, backgroundColor: UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0))
        }
        else{
            initialImageView.setImageWithName(name: name, backgroundColor: UIColor.init(red: 30/255, green: 108/255, blue: 60/255, alpha: 1.0))
        }
        
        pic.image = initialImageView.image
    }
}
