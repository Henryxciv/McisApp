//
//  facultyTVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/9/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import JSQMessagesViewController

class MessagesTVC: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var messagesTableView: UITableView!
    
    var userMessages = Dictionary<String, String>()
    let userID = KeychainWrapper.standard.string(forKey: "login")
    var users: [user] = []
    var filteredUsers: [user] = []
    var inSearchMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        DataServices.ds.Users_Ref.child(userID!).child("messages").observe(.childAdded, with: { (snapshot) -> Void in
            print(snapshot)
            let messageID = snapshot.value as! String
            
            if let otherP = snapshot.key as? String{
                self.userMessages.updateValue(messageID, forKey: otherP)
            }
            print(self.userMessages)
            self.messagesTableView.reloadData()
        })
        
        DataServices.ds.Users_Ref.observe(.childAdded, with: { (snapshot) -> Void in
            
            let userInfo = snapshot.value as! Dictionary<String, Any>
            let key = snapshot.key
            
            if let fname = userInfo["FirstName"] as! String!, let lname = userInfo["LastName"] as! String!, let email = userInfo["Email"] as! String!, let faculty = userInfo["Faculty"] as! String!{
                let userData = user(key: key, fname: fname, lname: lname, email: email, faculty: faculty)
                
                self.users.append(userData)
                self.messagesTableView.reloadData()
            }
        })
    }

    //searchbar functions
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            messagesTableView.reloadData()
            view.endEditing(true)
        }
        else{
            inSearchMode = true
            let lower = searchBar.text!
            filteredUsers = users.filter({$0._fname.range(of: lower) != nil || $0._lname.range(of: lower) != nil})
            messagesTableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if inSearchMode{
            return filteredUsers.count
        }
        return userMessages.count + 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let reuseidentifier = indexPath.row == 0 ? "generalCell":"chatCell"
        let reuseidentifier = "generalCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath) //as! MessagesCell
        if inSearchMode{
            let searchName = filteredUsers[indexPath.row]._fname + " " + filteredUsers[indexPath.row]._lname
            cell.textLabel?.text = searchName
        }else{
            if indexPath.row == 0{
                cell.textLabel?.text = "MCIS Chat"
            }
            else{
                let name = Array(userMessages)[indexPath.row-1].key
                cell.textLabel?.text = name
            }
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
