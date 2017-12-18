//
//  firstPageVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/13/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FirstPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //let keyChainResult = KeychainWrapper.standard.removeObject(forKey: "login")

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if let ID = KeychainWrapper.standard.string(forKey: "login"){
            performSegue(withIdentifier: "loggedIn", sender: nil)
            print("HEN: logged in \(ID)")
            
        }
        else{
            performSegue(withIdentifier: "loginPage", sender: nil)
            print("HEN: not logged in")
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
