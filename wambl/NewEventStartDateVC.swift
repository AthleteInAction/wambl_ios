//
//  NewEventDatesVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class NewEventStartDateVC: UIViewController {
    
    var event: Event!
    
    var events_delegate: AddEventPTC!
    
    var refresh_event_delegate: RefreshEventPTC!
    
    var existing: Bool = false

    @IBOutlet weak var start_date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    @IBAction func nextTPD(sender: UIBarButtonItem) {
        
        event.start_date = start_date.date
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("new_event_end_date_vc") as NewEventEndDateVC
        vc.event = event
        vc.events_delegate = events_delegate
        vc.existing = existing
        vc.loadView()
        
        if existing {
            
            vc.refresh_event_delegate = refresh_event_delegate
            vc.end_date.date = event.end_date
            
        }
        
        vc.end_date.minimumDate = event.start_date
        
        navigationController?.pushViewController(vc, animated: true)
        
    }

}