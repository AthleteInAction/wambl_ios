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
    
    var event_delegate: AddEventPTC!
    
    var existing: Bool = false
    
    var vc: NewEventAddPeopleVC!
    
    @IBOutlet weak var end_date: UIDatePicker!
    @IBOutlet weak var nextBTN: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if existing {
            
            nextBTN.title = "Save"
            
            end_date.date = event.end_date
            
        } else {
            
            end_date.date = event.start_date
            
            vc = storyboard?.instantiateViewControllerWithIdentifier("new_event_add_people_vc") as NewEventAddPeopleVC
            
        }
        
        end_date.minimumDate = event.start_date
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

    @IBAction func nextTPD(sender: UIBarButtonItem) {
        
        event.end_date = end_date.date
        
        if existing {
            
            navigationItem.title = "Saving..."
            
            event.save({ (s) -> Void in
                
                if s {
                    
                    self.event_delegate.addEvent(self.event)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                } else {
                    
                    self.nextBTN.enabled = true
                    self.navigationItem.title = "End Date"
                    
                }
                
            })
            
        } else {
            
            vc.event = event
            vc.existing = existing
            vc.events_delegate = event_delegate
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}
