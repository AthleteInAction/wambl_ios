//
//  EventsVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class EventsVC: UIViewController {

    var year: Int!
    
    @IBOutlet weak var yearBAR: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
        year = Int(components.year)
        
        yearBAR.topItem?.title = "\(year)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    @IBAction func yearPLUS(sender: UIBarButtonItem) {
        
        year = year+1
        yearBAR.topItem?.title = "\(year)"
        
    }
    
    @IBAction func yearMINUS(sender: UIBarButtonItem) {
        
        year = year-1
        yearBAR.topItem?.title = "\(year)"
        
    }
    
}
