//
//  LoginVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 12/16/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift
import SwiftKeychainWrapper

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }

    //MARK: Textfield Functions
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        // This should hide keyboard for the view.
        finishEditing()
    }
    func finishEditing(){
        view.endEditing(true)
    }
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        if let email = emailTextField.text, let pwd = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("HENRY: User successfully authenticated with FIR")
                    
                    if let user = user{
                        if user.isEmailVerified{
                            self.completeSignIn(id: user.uid)
                        }
                        else{
                            self.view.makeToast("Email not yet verified", duration: 3.0, position: .center)
                        }
                    }
                }
                else{
                    self.view.makeToast(error?.localizedDescription, duration: 3.0, position: .center)
                }
            })
        }
        
    }
    
    func completeSignIn(id: String){
        let keychainResult = KeychainWrapper.standard.set(id, forKey: "login")
        print("HENRY: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToApp", sender: nil)
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
