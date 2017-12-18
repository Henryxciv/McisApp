//
//  ViewController.swift
//  McisApp
//
//  Created by Henry Akaeze on 10/11/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var missingField: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Move TextFields to keyboard. Step 1: Add tap gesture to view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
 
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if (fnameField.text == "" || lnameField.text == "" || emailField.text == "" || passwordField.text == ""){
            missingField.isHidden = false
        }
        else if(codeField.text != "" && codeField.text != "1994"){
            missingField.isHidden = false
            missingField.text = "Wrong Faculty Code"
        }
        else{
            if let email = emailField.text, let pwd = passwordField.text{
                Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                    if error == nil {
                        print("HENRY: User successfully authenticated with FIR")
                        if let user = user{
                            self.completeSignIn(id: user.uid)
                        }
                    }
                    else{
                        Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                            if error != nil {
                                print("HENRY: Unable to authenticate with firebase using email")
                            }
                            else{
                                print("HENRY: User successfully created with FIR")
                                if let user = user{
                                    self.completeSignIn(id: user.uid)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    func returnData() -> Dictionary<String, String>{
        let fname = fnameField.text
        let lname = lnameField.text
        let email = emailField.text
        var faculty: String{
            if codeField.text == ""{
                return "False"
            }
            else{
                return "True"
            }
        }
        
        var dataArray = Dictionary<String, String>()
        let devicetoken = InstanceID.instanceID().token()!
        
        dataArray.updateValue(devicetoken, forKey: "fcmToken")
        dataArray.updateValue(fname!, forKey: "FirstName")
        dataArray.updateValue(lname!, forKey: "LastName")
        dataArray.updateValue(email!, forKey: "Email")
        dataArray.updateValue(faculty, forKey: "Faculty")
        
        return dataArray
    }
    
    
    func completeSignIn(id: String){
        let userData = returnData()
        
        DataServices.ds.createUsers(uid: id, data: userData)        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: "login")
        print("HENRY: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToApp", sender: nil)
    }
    
    
    
    //MARK: Textfield Functions
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        // This should hide keyboard for the view.
        finishEditing()
    }
    func finishEditing(){
        view.endEditing(true)
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        finishEditing()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        finishEditing()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:160), animated: true)
    }
}

