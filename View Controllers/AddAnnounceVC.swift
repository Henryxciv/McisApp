//
//  AddAnnounceVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/16/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit

class AddAnnounceVC: UIViewController,UITextViewDelegate, UITextFieldDelegate{

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateDisplayButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var refreshmentTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var toolBarWithDone: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set minimum date for picker to current date and time
        datePicker.minimumDate = Date()
        
        //let default date be current date to prevent nil error
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let strDate = dateFormatter.string(from: Date())
        
        dateDisplayButton.setTitle(strDate, for:.normal)
        
        //edit view components
        titleTextField.layer.borderWidth = 0.5
        dateDisplayButton.layer.borderWidth = 0.5
        detailsTextView.layer.borderWidth = 0.5
        
        dateDisplayButton.layer.cornerRadius = 10
        dateDisplayButton.clipsToBounds = true
        
        detailsTextView.layer.cornerRadius = 10
        detailsTextView.clipsToBounds = true
        
        titleTextField.layer.cornerRadius = 10
        titleTextField.clipsToBounds = true
        
        submitButton.layer.cornerRadius = 10
        submitButton.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        
        // Do any additional setup after loading the view.
    }
    
    func refreshColors(){
        titleTextField.layer.borderColor = UIColor.black.cgColor
        detailsTextView.layer.borderColor = UIColor.black.cgColor
        dateDisplayButton.layer.borderColor = UIColor.black.cgColor
        locationTextField.layer.borderColor = UIColor.black.cgColor
        refreshmentTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func didTapDone(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let strDate = dateFormatter.string(from: datePicker.date)
        
        dateDisplayButton.setTitle(strDate, for:.normal)
        toolBarWithDone.isHidden = true
        datePicker.isHidden = true
        
    }
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        // This should hide keyboard for the view.
        view.endEditing(true)
    }
    
    @IBAction func didPressSend(_ sender: Any) {
        if titleTextField.text == ""{
            refreshColors()
            titleTextField.layer.borderColor = UIColor.red.cgColor
        }
        else if detailsTextView.text == ""{
            refreshColors()
            detailsTextView.layer.borderColor = UIColor.red.cgColor
        }
        
        else{
            if let poster = DataServices.ds.user{
                
                let sender = poster._fname + " " + poster._lname
                let title = titleTextField.text!
                let details = detailsTextView.text!
                let date = dateDisplayButton.titleLabel?.text
                let refresh = refreshmentTextField.text!
                let location = locationTextField.text!
                
                var announcement = Dictionary<String, String>()
                
                announcement.updateValue(sender, forKey: "author")
                announcement.updateValue(date!, forKey: "date")
                announcement.updateValue(details, forKey: "details")
                announcement.updateValue(title, forKey: "title")
                announcement.updateValue(location, forKey: "location")
                announcement.updateValue(refresh, forKey: "refreshment")
                
                let announceRef = DataServices.ds.Announcement_Ref.childByAutoId()
                
                announceRef.updateChildValues(announcement)
                
                _ = navigationController?.popToRootViewController(animated: true)
            }
            
            else{
                print("COULD NOT POST ANNOUNCMENT")
            }
        }
    }
    @IBAction func didTouchDate(_ sender: Any) {
        view.endEditing(true)
        datePicker.isHidden = false
        toolBarWithDone.isHidden = false
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
