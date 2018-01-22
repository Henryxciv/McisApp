//
//  AnnouncementTVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 10/11/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase
import FirebaseMessaging
import Toast_Swift

class AnnouncementTVC: UITableViewController {
    
    var announcementArray: [announcement] = []
    
    @IBOutlet weak var addAnnounceBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ID = KeychainWrapper.standard.string(forKey: "login")
        
        Messaging.messaging().subscribe(toTopic: "announcements")
        
        //to populate table view
        DataServices.ds.Announcement_Ref.observe(.childAdded, with: { (snapshot) -> Void in
            let announce = snapshot.value as! Dictionary<String, String>
            
            let announce_key = snapshot.key
            
            if let announceTitle = announce["title"] as String!, let announceAuthor = announce["author"] as String!, let announceDate = announce["date"] as String!, let announceDetail = announce["details"] as String!, let locate = announce["location"] as String!, let refresh = announce["refreshment"] as String!{
                
                let data = announcement(key: announce_key, title: announceTitle, author: announceAuthor, date: announceDate, details: announceDetail, loc: locate, ref: refresh)
                
                self.announcementArray.insert(data, at: 0)
                
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                self.tableView.endUpdates()
            }
        })
        
        //to delete table cell if cell is removed from firebase
        DataServices.ds.Announcement_Ref.observe(.childRemoved) { (snapshot) -> Void in
            print(snapshot)
            
            //let announce = snapshot.value as! Dictionary<String, String>
            
            let announce_key = snapshot.key
            
            let index = self.announcementArray.index(where: { $0._announce_key == announce_key })
            
            self.announcementArray.remove(at: index!)
            
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [IndexPath(row: index!, section: 0)], with: .automatic)
            self.tableView.endUpdates()
            
        }
        
        //to get user data and store it for user
        DataServices.ds.Users_Ref.child(ID!).observe(.value) { (snapshot) -> Void in
            
            let userInfo = snapshot.value as! Dictionary<String, Any>
            let key = snapshot.key
            
            if let fname = userInfo["FirstName"] as! String!, let lname = userInfo["LastName"] as! String!, let email = userInfo["Email"] as! String!, let faculty = userInfo["Faculty"] as! String!{
                
                let userData = user(key: key, fname: fname, lname: lname, email: email, faculty: faculty)
                
                DataServices.ds.user = userData
                if faculty == "True"{
                    self.addAnnounceBtn.isEnabled = true
                }
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedAnnouncement = announcementArray[indexPath.row]
                let detailScene = segue.destination as? AnnouncementDetailsVC
                detailScene?.announcement = selectedAnnouncement
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return announcementArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "AnnounceCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        
        let announcecell = cell as! AnnounceCell
        let ann = announcementArray[indexPath.row]
 
        announcecell.configure(poster: ann._author, title: ann._title, date: ann._date, details: ann._details, loc: ann._location, ref: ann._refreshment)
        if ann._refreshment != "Y"{
            announcecell.foodLbl.isHidden = true
        }
        return announcecell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Click Calendar Icon to add to calendar"
        }
        return "Here"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.init(red: 1/255, green: 116/255, blue: 45/255, alpha: 1.0)
        header.textLabel?.font = UIFont.init(name: "American Typewriter", size: 13)
        header.textLabel?.textAlignment = NSTextAlignment.center
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

    
    
    @IBAction func logoutPressed(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: "login")
        print("HENRY: Keychain removed \(keyChainResult)")
        try! Auth.auth().signOut()
        goToLogin()
    }
    
    func goToLogin () {
        let loginPageView =  self.storyboard?.instantiateViewController(withIdentifier: "loginPage")
        self.present(loginPageView!, animated: true, completion: nil)
    }
    
}
