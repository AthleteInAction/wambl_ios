//
//  NewEventDatesVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class NewEventStartDateVC: UIViewController {
    
    var new_event: PFObject!

    @IBOutlet weak var start_date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "start_to_end" {
            
            new_event["start_date"] = start_date.date
            
            var vc = segue.destinationViewController as NewEventEndDateVC
            vc.new_event = new_event
            
        }
        
    }

}