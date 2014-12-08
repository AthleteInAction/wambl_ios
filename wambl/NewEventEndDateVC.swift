//
//  NewEventEndDateVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class NewEventEndDateVC: UIViewController {
    
    var event: Event!
    
    var events_delegate: AddEventPTC!
    
    var refresh_event_delegate: RefreshEventPTC!
    
    var existing: Bool = false
    
    @IBOutlet weak var end_date: UIDatePicker!
    @IBOutlet weak var nextBTN: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("END DATE VIEW DID LOAD")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if existing {
            
            nextBTN.title = "Save"
            
        } else {
            
            nextBTN.title = "Next"
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func nextTPD(sender: UIBarButtonItem) {
        
        event.end_date = end_date.date
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("new_event_add_people_vc") as NewEventAddPeopleVC
        
        if existing {
            
            navigationItem.title = "Saving..."
            
            event.save({ (s) -> Void in
                
                if s {
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } else {
                    
                    self.nextBTN.enabled = true
                    self.navigationItem.title = "End Date"
                    
                }
                
                self.refresh_event_delegate.refreshEvent(self.event)
                
            })
            
        } else {
            
            vc.event = event
            vc.existing = existing
            vc.events_delegate = events_delegate
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}
