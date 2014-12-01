//
//  EventsVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var year: Int!
    
    var events: [Event] = []
    var selected_event: Event!
    
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var yearBAR: UINavigationBar!
    @IBOutlet weak var eventsTBL: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsTBL.delegate = self
        eventsTBL.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        eventsTBL.addSubview(refreshControl)
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitMonth | .CalendarUnitYear | .CalendarUnitDay, fromDate: date)
        year = Int(components.year)
        
        yearBAR.topItem?.title = "\(year)"
        
        loadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    func loadData(){
        
        var admins_done = false
        var users_done = false
        
        var tmp_events: [Event] = []
        
        var users_query = PFQuery(className: "Events")
        users_query.whereKey("users", containedIn: [currentUser])
        
        var admins_query = PFQuery(className: "Events")
        admins_query.whereKey("admins", containedIn: [currentUser])
        
        users_query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil){
                
                for object in objects {
                    
                    var event = object as PFObject
                    
                    var tmp_event = Event()
                    tmp_event.object = event
                    
                    tmp_events.append(tmp_event)
                    
                }
                
            } else {
                
                NSLog("USERS QUERY ERROR")
                
            }
            
            users_done = true
            
            if admins_done {
                
                self.setData(tmp_events)
                
            }
            
        }
        
        admins_query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil){
                
                for object in objects {
                    
                    var event = object as PFObject
                    
                    var tmp_event = Event()
                    tmp_event.object = event
                    tmp_event.admin = true
                    
                    var creator = event["creator"] as PFUser
                    
                    if creator.objectId == currentUser.objectId {
                        
                        tmp_event.creator = true
                        
                    }
                    
                    tmp_events.append(tmp_event)
                    
                }
                
            } else {
                
                NSLog("ADMINS QUERY ERROR")
                
            }
            
            admins_done = true
            
            if users_done {
                
                self.setData(tmp_events)
                
            }
            
        }
        
    }
    
    func setData(tmp_events: Array<Event>){
        
        self.events = tmp_events
        
        self.eventsTBL.reloadData()
        
        self.refreshControl.endRefreshing()
        
    }
    
    @IBAction func yearPLUS(sender: UIBarButtonItem) {
        
        year = year+1
        yearBAR.topItem?.title = "\(year)"
        
    }
    
    @IBAction func yearMINUS(sender: UIBarButtonItem) {
        
        year = year-1
        yearBAR.topItem?.title = "\(year)"
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return events.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as EventCell
        
        var event = events[indexPath.row].object
        
        cell.nameTXT.text = event["name"] as? String
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var event: Event = events[indexPath.row] as Event
        selected_event = event
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("event_from_events", sender: nil)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var event: Event = events[indexPath.row] as Event
        var event_name: String = event.object["name"] as String
        var cell = tableView.cellForRowAtIndexPath(indexPath) as EventCell
        
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit" , handler: { (a: UITableViewRowAction!, i: NSIndexPath!) -> Void in
            
            var editMenu = UIAlertController(title: "Edit", message: nil, preferredStyle: .ActionSheet)
            
            var changeName = UIAlertAction(title: "Change Details", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction!) -> Void in
                
                tableView.setEditing(false, animated: true)
                
                var vc = self.storyboard?.instantiateViewControllerWithIdentifier("new_event_vc") as NewEventVC
                vc.event = event.object
                
                let nav = UINavigationController(rootViewController: vc)
                
                self.presentViewController(nav, animated:true, completion: nil)
                
            })
            
            let leaveEvent = UIAlertAction(title: "Leave Event", style: UIAlertActionStyle.Destructive, handler: {(alert: UIAlertAction!) in
                
                
                
            })
            
            let deleteEvent = UIAlertAction(title: "Delete Event", style: UIAlertActionStyle.Destructive, handler: {(alert: UIAlertAction!) in
                
                var confirmAlert: UIAlertController!
                
                confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you wish to delete \(event_name)?", preferredStyle: UIAlertControllerStyle.Alert)
                
                confirmAlert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action: UIAlertAction!) in
                    
                    cell.loader.startAnimating()
                    
                    event.object.deleteInBackgroundWithBlock({ (success: Bool!, error: NSError!) -> Void in
                        
                        if !(error != nil) {
                            
                            self.events.removeAtIndex(indexPath.row)
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            
                        } else {
                            
                            var code = error.userInfo?["code"] as Int
                            var error_string = error.userInfo?["error"] as String
                            Error.report(currentUser, code: code, error: error_string, alert: true, p: self)
                            
                            tableView.setEditing(false, animated: true)
                            
                        }
                        
                        cell.loader.stopAnimating()
                        
                    })
                    
                }))
                
                confirmAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                    
                    tableView.setEditing(false, animated: true)
                    
                }))
                
                self.presentViewController(confirmAlert, animated: true, completion: nil)
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(alert: UIAlertAction!) in
            
                tableView.setEditing(false, animated: true)
            
            })
            
            if event.admin {
                editMenu.addAction(changeName)
            }
            if event.creator {
                editMenu.addAction(deleteEvent)
            } else {
                editMenu.addAction(leaveEvent)
            }
            editMenu.addAction(cancelAction)
            
            self.presentViewController(editMenu, animated: true, completion: nil)
            
        })
        
        editAction.backgroundColor = UIColor.grayColor()
        
        return [editAction]
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "event_from_events" {
            
            var vc = segue.destinationViewController as EventDetailVC
            vc.event = selected_event
            
        }
        
    }
    
}
