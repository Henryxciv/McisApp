//
//  faculty.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/9/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import Foundation
import UIKit

class faculty {
    var fname: String
    var lname: String
    var description: String
    var picture: UIImage
 
    init(first: String, last: String, des: String, pic: UIImage) {
        self.fname = first
        self.lname = last
        self.description = des
        self.picture = pic
    }
}

class user{
    var _key: String
    var _fname: String
    var _lname: String
    var _email: String
    var _faculty: String
    
    init(key: String, fname: String, lname: String, email: String, faculty: String) {
        self._fname = fname
        self._lname = lname
        self._email = email
        self._faculty = faculty
        self._key = key
    }
}

class announcement{
    var _title: String
    var _author: String
    var _date: String
    var _details: String
    var _announce_key: String
    var _location: String
    var _refreshment: String
    
    init(key: String, title: String, author: String, date: String, details: String, loc: String, ref: String) {
        self._announce_key = key
        self._title = title
        self._author = author
        self._date = date
        self._details = details
        self._location = loc
        self._refreshment = ref
    }
}

class department{
    
    func getMathFaculty() -> [faculty] {
        var mathematics = [faculty]()
        mathematics.append(faculty(first: "Edgar", last: "Holman", des: "Instructor", pic: UIImage.init(named: "eholman")! ))
        mathematics.append(faculty(first: "Latonya", last: "Garner", des: "Department Chair/Instructor", pic: UIImage.init(named: "lgarner")! ))
        mathematics.append(faculty(first: "Jinlong", last: "Ye", des: "Instructor", pic: UIImage.init(named: "jinglongye")! ))
        mathematics.append(faculty(first: "Xiaoqin", last: "wu", des: "Instructor", pic: UIImage.init(named: "xiaoqinwu")! ))
        return mathematics
    }
    
    func getCompFaculty() -> [faculty] {
        var compScience = [faculty]()
        compScience.append(faculty(first: "Timothy", last: "Holston", des: "Instructor", pic: UIImage.init(named: "tholston")! ))
        compScience.append(faculty(first: "Stacy", last: "White", des: "Instructor", pic: UIImage.init(named: "swhite")! ))
        compScience.append(faculty(first: "Marcus", last: "Golden", des: "Instructor", pic: UIImage.init(named: "mgolden")! ))
        return compScience
    }
}
