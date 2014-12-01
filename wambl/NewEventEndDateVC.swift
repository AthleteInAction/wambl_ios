//
//  NewEventEndDateVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class NewEventEndDateVC: UIViewController {
    
    var event: PFObject!
    var existing: Bool = false
    var vc: NewEventAddPeopleVC!
    
    @IBOutlet weak var end_date: UIDatePicker!
    @IBOutlet weak var nextBTN: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if existing {
            
            nextBTN.title = "Save"
            
            end_date.date = event["end_date"] as NSDate
            
        } else {
            
            end_date.date = event["start_date"] as NSDate
            
            vc = storyboard?.instantiateViewControllerWithIdentifier("new_event_add_people_vc") as NewEventAddPeopleVC
            vc.getAppContacts()
            
        }
        end_date.minimumDate = event["start_date"] as? NSDate
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func nextTPD(sender: UIBarButtonItem) {
        
        event["end_date"] = end_date.date
        
        if existing {
            
            navigationItem.title = "Saving..."
            
            event.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                
                if success {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } else {
                    
                    var code: Int = error.userInfo?["code"] as Int
                    var error_string: String = error.userInfo?["error"] as String
                    Error.report(currentUser, code: code, error: error_string, alert: true, p: self)
                    
                    self.nextBTN.enabled = true
                    
                    self.navigationItem.title = "End Date"
                    
                }
                
            }
            
        } else {
            
            vc.event = event
            vc.existing = existing
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}
