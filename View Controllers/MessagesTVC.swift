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
    
    let userID = KeychainWrapper.standard.string(forKey: "login")
    
    var userMessages = Dictionary<String, String>()
    var users: [user] = []
    var dispalyedUsers: [user] = []
    var filteredUsers: [user] = []
    var inSearchMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.tableView.register(MessagesCell.self, forCellReuseIdentifier: "generalCell")
        
        DataServices.ds.Users_Ref.child(userID!).child("messages").observe(.childAdded, with: { (snapshot) -> Void in
            print(snapshot)
            let messageID = snapshot.value as! String
            
            if let otherParty = snapshot.key as? String{
                self.userMessages.updateValue(messageID, forKey: otherParty)
                
                for user in self.users{
                    if user._key == otherParty{
                        self.dispalyedUsers.append(user)
                    }
                }
            }
            
            self.messagesTableView.reloadData()
        })
        
        DataServices.ds.Users_Ref.observe(.childAdded, with: { (snapshot) -> Void in
            
            let userInfo = snapshot.value as! Dictionary<String, Any>
            let key = snapshot.key
            
            if let fname = userInfo["FirstName"] as! String!, let lname = userInfo["LastName"] as! String!, let email = userInfo["Email"] as! String!, let faculty = userInfo["Faculty"] as! String!{
                let userData = user(key: key, fname: fname, lname: lname, email: email, faculty: faculty)
                
                //check if user key is already in communication with this person
                for key in self.userMessages.keys{
                    if userData._key == key{
                        self.dispalyedUsers.append(userData)
                    }
                }
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
            filteredUsers = users.filter({($0._fname.range(of: lower) != nil || $0._lname.range(of: lower) != nil) && $0._key != userID})
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
        return dispalyedUsers.count
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let reuseidentifier = indexPath.row == 0 ? "generalCell":"chatCell"
        let reuseidentifier = "generalCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath) as! MessagesCell
        
        if inSearchMode{
            let user = filteredUsers[indexPath.row]
            cell.configure(user: user)
        }else{
            let user = dispalyedUsers[indexPath.row]
            cell.configure(user: user)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = MessagesCell()
        
        if inSearchMode{
            cell.cellUser = filteredUsers[(indexPath as NSIndexPath).row]
        }
        else{
            cell.cellUser = dispalyedUsers[(indexPath as NSIndexPath).row]
        }
        self.performSegue(withIdentifier: "showChat", sender: cell)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let cell = sender as? MessagesCell {
            let chatVc = segue.destination as! ChatVC
            
            let recipientID = cell.cellUser._key
            let chatRefString = userID?.compare(recipientID, options: .anchored) == .orderedAscending ? userID! + "-" + recipientID:recipientID + "-" + userID!
            chatVc.recipient = cell.cellUser
            
            chatVc.chatRef = DataServices.ds.Chat_Ref.child(chatRefString)
        }
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
