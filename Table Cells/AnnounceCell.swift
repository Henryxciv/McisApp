//
//  AnnounceCell.swift
//  McisApp
//
//  Created by Henry Akaeze on 10/12/17.
//  Copyright © 2017 Henry Akaeze. All rights reserved.
//

import UIKit
import EventKit
import Toast_Swift

class AnnounceCell: UITableViewCell {
    @IBOutlet weak var senderLbl: UILabel!
    @IBOutlet weak var foodLbl: UILabel!    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var datesLbl: UILabel!
    
    var dateString = String()
    var titleString = String()
    var detailString = String()
    var location  = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addToCalendar(_ sender: Any) {
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
                if singleEvent.title == self.titleString || singleEvent.startDate == eventDate! {
                    notExist = false
                }
            }
            
            if (granted && notExist){
                print("granted calender access")
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.titleString
                event.startDate = eventDate!
                
                event.endDate = endDate!
                event.notes = self.detailString
                event.location = self.location
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                
                do{
                    try eventStore.save(event, span: .thisEvent)
                    DispatchQueue.main.async {
                        self.superview?.makeToast("Event has been added to your phone's calendar", duration: 3.0, position: .center, title: "Event Added", image: UIImage(named: "calendar-256.png"))
                    }
                }catch let error as NSError{
                    print("ERROR: \(error)")
                }
                
            }
            else{
                DispatchQueue.main.async {
                    var style = ToastStyle()

                    style.messageAlignment = .center
                    //style.backgroundColor = UIColor.init(red: 196/255, green: 28/255, blue: 25/255, alpha: 1.0)
                    self.superview?.makeToast("Event already created", duration: 2.0, position: .center, style: style)
                }
                
                print("Error in creating or event already exists")
            }
        }
        
    }
    
    func configure(poster: String, title: String, date: String, details: String, loc: String, ref: String) {
        detailString = details
        dateString = date
        titleString = title
        TitleLbl.text = title
        senderLbl.text = poster
        
        var datePlace = date
        if loc != ""{
            datePlace += " @ " + loc
        }
        datesLbl.text = datePlace
        location = loc
        
//        if ref != "Y"{
//            foodLbl.isHidden = true
//        }
    }

}
