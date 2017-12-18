//
//  LoginVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 12/16/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import Toast_Swift

class LoginVC: UIViewController {

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
        self.view.makeToast("This is a piece of toast", duration: 2.0, position: .bottom, title: "Toast Title", image: UIImage(named: "crest.png")) { didTap in
            if didTap {
                print("completion from tap")
            } else {
                print("completion without tap")
            }
        }
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
