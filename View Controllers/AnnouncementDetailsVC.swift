//
//  AnnouncementDetailsVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/23/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit

class AnnouncementDetailsVC: UIViewController {

    var announcement: announcement!
    
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet weak var refreshmentField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsTextView.text = announcement._details
        dateField.text = announcement._date
        locationField.text = announcement._location
        
        let ref = announcement._refreshment
        if ref == "Y"{
            refreshmentField.text = "Refreshment will be provided"
        }
        else{
            refreshmentField.text = "Refreshment will not be provided"
        }
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
