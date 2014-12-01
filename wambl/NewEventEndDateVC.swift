//
//  NewEventEndDateVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class NewEventEndDateVC: UIViewController {
    
    var new_event: PFObject!
    
    @IBOutlet weak var end_date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        end_date.date = new_event["start_date"] as NSDate
        end_date.minimumDate = new_event["start_date"] as? NSDate
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "end_to_add" {
            
            new_event["end_date"] = end_date.date
            
            var vc = segue.destinationViewController as NewEventAddPeopleVC
            vc.new_event = new_event
            
        }
        
    }

}
