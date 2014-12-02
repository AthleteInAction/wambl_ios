//
//  Date.swift
//  wambl
//
//  Created by grobinson on 12/1/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import Foundation

class Date {
    
    class func fullString(date: NSDate) -> String {
        
        let d: [String] = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        
        let m: [String] = [
            "January",
            "Febuary",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        ]
        
        let calendar = NSCalendar.currentCalendar()
        let c = calendar.components(.MonthCalendarUnit | .DayCalendarUnit | .WeekdayCalendarUnit | .YearCalendarUnit, fromDate: date)
        
        return "\(d[c.weekday-1]), \(m[c.month-1]) \(c.day), \(c.year)"
        
    }
    
}