//
//  EventsVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

protocol RefreshEventPTC {
    
    func refreshEvent(event: Event)
    
}

class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddEventPTC, RefreshEventPTC {

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
        
        DB.getEvents { (s, e) -> Void in
            
            if s {
                
                self.events = e
                
            }
            
            self.setData()
            
        }
        
    }
    
    func setData(){
        
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
        
        var event = events[indexPath.row]
        
        cell.nameTXT.text = event.name
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var event: Event = events[indexPath.row] as Event
        
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("event_detail_vc") as EventDetailVC
        vc.event = event
        vc.refresh_event_delegate = self
        vc.loadView()
        if event.is_loaded {
            vc.setData()
        } else {
            vc.loadAll()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var event: Event = events[indexPath.row] as Event
        
        var cell = tableView.cellForRowAtIndexPath(indexPath) as EventCell
        
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Edit" , handler: { (a: UITableViewRowAction!, i: NSIndexPath!) -> Void in
            
            var editMenu = UIAlertController(title: "EDIT", message: nil, preferredStyle: .ActionSheet)
            
            let leaveEvent = UIAlertAction(title: "Leave Event", style: UIAlertActionStyle.Destructive, handler: {(alert: UIAlertAction!) in
                
                var confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you wish to leave \(event.name)?", preferredStyle: UIAlertControllerStyle.Alert)
                
                confirmAlert.addAction(UIAlertAction(title: "Leave", style: .Destructive, handler: { (action: UIAlertAction!) in
                    
                    cell.loader.startAnimating()
                    
                    event.invited.removeObject(currentUser)
                    
                    event.save({ (s) -> Void in
                        
                        if s {
                            
                            self.events.removeAtIndex(indexPath.row)
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            
                        } else {
                            
                            event.invited.addObject(currentUser)
                            
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
            
            let deleteEvent = UIAlertAction(title: "Delete Event", style: UIAlertActionStyle.Destructive, handler: {(alert: UIAlertAction!) in
                
                var confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you wish to delete \(event.name)?", preferredStyle: UIAlertControllerStyle.Alert)
                
                confirmAlert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action: UIAlertAction!) in
                    
                    cell.loader.startAnimating()
                    
                    event.delete({ (s) -> Void in
                        
                        if s {
                            
                            self.events.removeAtIndex(indexPath.row)
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                            
                        } else {
                            
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
            
            if event.i_am_creator {
                editMenu.addAction(deleteEvent)
            }
            editMenu.addAction(leaveEvent)
            editMenu.addAction(cancelAction)
            
            self.presentViewController(editMenu, animated: true, completion: nil)
            
        })
        
        editAction.backgroundColor = UIColor.redColor()
        
        return [editAction]
        
    }
    
    func addEvent(event: Event){
        
        events.insert(event, atIndex: 0)
        setData()
        
    }
    
    @IBAction func addTPD(sender: UIBarButtonItem) {
        
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("new_event_vc") as NewEventVC
        vc.events_delegate = self
        vc.event = Event(event: nil)
        
        var nav = UINavigationController(rootViewController: vc)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func refreshEvent(event: Event){
        
        for i in 0..<countElements(events) {
            
            if event.parse.objectId == events[i].parse.objectId {
                
                events[i] = event
                break
                
            }
            
        }
        
        setData()
        
    }
    
}