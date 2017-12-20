//
//  AnnouncementDetailsVC.swift
//  McisApp
//
//  Created by Henry Akaeze on 11/23/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import EventKit
import Toast_Swift

class AnnouncementDetailsVC: UIViewController {

    var announcement: announcement!
    
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var dateField: UILabel!
    @IBOutlet weak var locationField: UILabel!
    @IBOutlet weak var refreshmentField: UILabel!
    @IBOutlet weak var refreshmentLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailsTextView.text = announcement._details
        dateField.text = announcement._date
        locationField.text = announcement._location
        
        let ref = announcement._refreshment
        if ref == "Y"{
            refreshmentField.text = "Refreshment will be provided"
        }
        else{
            refreshmentField.isHidden = true
            refreshmentLabel.isHidden = true
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func addToCalendar(_ sender: Any) {
        addToCalendar1(announce: announcement)
    }
    
    func addToCalendar1(announce: announcement){
        let dateString = announce._date
        let titleString = announce._title
        let detailString = announce._details
        let location = announce._location
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let eventDate = dateFormatter.date(from: dateString)
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .minute, value: 60, to: eventDate!)
        
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            let startDate = eventDate
            let endDate = endDate
            let predicate = eventStore.predicateForEvents(withStart: startDate!, end: endDate!, calendars: nil)
            let existingEvents = eventStore.events(matching: predicate)
            
            var notExist = true
            
            for singleEvent in existingEvents {
                if singleEvent.title == titleString || singleEvent.startDate == eventDate! {
                    notExist = false
                }
            }
            
            if (granted && notExist){
                print("granted calender access")
                DispatchQueue.main.async {
                    self.view.makeToast("Event has been added to your phone's calendar", duration: 3.0, position: .center, title: "Event Added", image: UIImage(named: "calendar-256.png"))
                }
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = titleString
                event.startDate = eventDate!
                
                event.endDate = endDate!
                event.notes = detailString
                event.location = location
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                
                do{
                    try eventStore.save(event, span: .thisEvent)
                }catch let error as NSError{
                    print("ERROR: \(error)")
                }
                
            }
            else{
                DispatchQueue.main.async {
                    var style = ToastStyle()
                    
                    // this is just one of many style options
                    style.messageAlignment = .center
                    self.view.makeToast("Event already created", duration: 2.0, position: .center, style: style)
                }
                
                print("Error in creating or event already exists")
            }
        }
    }
    
    
}
