//
//  ViewController.swift
//  McisApp
//
//  Created by Henry Akaeze on 10/11/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift
import SwiftKeychainWrapper

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    var loggedIn: Bool = true
    
    @IBOutlet weak var backToLoginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordLbl: UILabel!
    @IBOutlet weak var updateBtn: UIButton!
    
    @IBOutlet weak var fnameField: UITextField!
    @IBOutlet weak var lnameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var codeField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Move TextFields to keyboard. Step 1: Add tap gesture to view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        if loggedIn{
            signUpBtn.isHidden = true
        }else{
            updateBtn.isHidden = true
        }
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if loggedIn{
            let currentUser = DataServices.ds.user
            fnameField.text = currentUser?._fname
            lnameField.text = currentUser?._lname
            emailField.text = currentUser?._email
            passwordLbl.text = "Update Password"
            emailField.isEnabled = false
//            passwordField.isEnabled = false
//            confirmPasswordField.isEnabled = false
            codeField.isEnabled = false
            //backToLoginBtn.titleLabel?.text = "Sign Out"
            
        }
        else{
            passwordLbl.text = "Password"
            backToLoginBtn.titleLabel?.text = "Back to login"
        }
    }
    
    @IBAction func backToLoginPressed(_ sender: Any) {
        if loggedIn{
            let keyChainResult = KeychainWrapper.standard.removeObject(forKey: "login")
            print("HENRY: Keychain removed \(keyChainResult)")
            try! Auth.auth().signOut()
        }
        performSegue(withIdentifier: "goToLogin", sender: nil)
    }
    
    @IBAction func updatePressed(_ sender: Any) {
        if let newFName = fnameField.text, let newLName = lnameField.text, let pass = passwordField.text{
            let currentUser = DataServices.ds.user
            
            if let key = currentUser?._key{
                if newFName != ""{
                    DataServices.ds.Users_Ref.child(key).updateChildValues(["FirstName" : newFName])
                }
                if newLName != ""{
                    DataServices.ds.Users_Ref.child(key).updateChildValues(["LastName": newLName])
                }
                self.view.makeToast("Information Updated", duration: 3.0, position: .center)
            }
            if pass != ""{
                if (passwordField.text != confirmPasswordField.text){
                    self.view.makeToast("Password do not match", duration: 3.0, position: .center)
                }
                else{
                    Auth.auth().currentUser?.updatePassword(to: pass, completion: { (error) in
                        self.view.makeToast(error?.localizedDescription, duration: 3.0, position: .center)
                    })
                }
            }
            
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if !loggedIn{
            if (fnameField.text == "" || lnameField.text == "" || emailField.text == "" || passwordField.text == ""){
                self.view.makeToast("An important field is left empty", duration: 3.0, position: .center)
            }
            else if (passwordField.text != confirmPasswordField.text){
                self.view.makeToast("Password do not match", duration: 3.0, position: .center)
            }
            else if(codeField.text != "" && codeField.text != "1994"){
                self.view.makeToast("Wrong faculty code", duration: 3.0, position: .center)
            }
            else{
                if let email = emailField.text, let pwd = passwordField.text{
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("HENRY: Unable to create user with firebase using email")
                            self.view.makeToast(error?.localizedDescription, duration: 3.0, position: .center)
                        }
                        else{
                            print("HENRY: User successfully created with FIR")
                            if let user = user{
                                user.sendEmailVerification(completion: { (error) in
                                    print("\(error?.localizedDescription)")
                                })
                                
                                self.view.makeToast("Check email for verification", duration: 5.0, position: .center)
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                    
                }
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
        performSegue(withIdentifier: "goToLogin", sender: nil)
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

