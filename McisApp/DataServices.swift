//
//  dataServices.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/13/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import Foundation
import Firebase

let DBase_ref = Database.database().reference()

class DataServices{
    static let ds = DataServices()
    
    var user: user!
    
    private var _DB_ref = DBase_ref
    private var _users_ref = DBase_ref.child("users")
    private var _faculty_ref = DBase_ref.child("faculty")
    private var _announce_ref = DBase_ref.child("announcements")
    private var _messages_ref = DBase_ref.child("messages")
    private var _chat_ref = DBase_ref.child("chat")
    
    var DB_Ref: DatabaseReference{
        return _DB_ref
    }
    
    var Users_Ref: DatabaseReference{
        return _users_ref
    }
    
    var Faculty_Ref: DatabaseReference{
        return _faculty_ref
    }
    
    var Announcement_Ref: DatabaseReference{
        return _announce_ref
    }
    
    var Messages_Ref: DatabaseReference{
        return _messages_ref
    }
    
    var Chat_Ref: DatabaseReference{
        return _chat_ref
    }
    
    func createUsers(uid: String, data: Dictionary<String, String> ){
        Users_Ref.child(uid).updateChildValues(data)
    }
}
