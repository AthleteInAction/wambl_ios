//
//  NewEventDatesVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class NewEventStartDateVC: UIViewController {
    
    var event: PFObject!
    var existing: Bool = false

    @IBOutlet weak var start_date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if existing {
            
            start_date.date = event["start_date"] as NSDate
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "start_to_end" {
            
            event["start_date"] = start_date.date
            
            var vc = segue.destinationViewController as NewEventEndDateVC
            vc.event = event
            vc.existing = existing
            
        }
        
    }

}