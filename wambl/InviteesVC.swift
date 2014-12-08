//
//  InviteesVC.swift
//  wambl
//
//  Created by grobinson on 12/7/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class InviteesVC: UITableViewController, RefreshEventPTC {
    
    var refresh_event_delegate: RefreshEventPTC!
    
    var event: Event!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invitees"
        
    }
    
    func addTPD(){
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("invite_vc") as InviteVC
        vc.event = event
        vc.refresh_event_delegate = self
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func setData(){
        
//        checkAdmins()
//        checkConfirmed()
        
        event.i_am_creator = (event.creator.objectId == currentUser.objectId)
        
        var addBTN = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addTPD")
        
        if event.i_am_admin {
            
            navigationItem.rightBarButtonItem = addBTN
            
        } else {
            
            navigationItem.rightBarButtonItem = nil
            
        }
        
        event.invited_list.sort({$0.sort_name < $1.sort_name})
        
        var x: Int?
        for i in 0..<countElements(event.invited_list) {
            
            if currentUser.objectId == event.invited_list[i].user.objectId {
                
                x = i
                break
                
            }
            
        }
        
        if x != nil {
            
            var tmp: Contact = event.invited_list[x!] as Contact
            event.invited_list.removeAtIndex(x!)
            event.invited_list.insert(tmp, atIndex: 0)
            
        }
        
        refresh_event_delegate.refreshEvent(event)
        
        tableView.reloadData()
        
    }
    
    func checkAdmins() {
        
        for i in 0..<countElements(event.invited_list) {
            
            for a in event.admins_list {
                
                if event.invited_list[i].user.objectId == a.objectId {
                    
                    event.invited_list[i].admin = true
                    
                }
                
            }
            
        }
        
    }
    
    func checkConfirmed() {
        
        for i in 0..<countElements(event.invited_list) {
            
            for a in event.confirmed_list {
                
                if event.invited_list[i].user.objectId == a.objectId {
                    
                    event.invited_list[i].confirmed = true
                    
                }
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return event.invited_list.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as InviteeCell
        cell.event = event
        cell.refresh_event_delegate = refresh_event_delegate
        
        let invitee = event.invited_list[indexPath.row]
        
        cell.user = invitee.user
        
        if invitee.user.objectId == currentUser.objectId {
            
            cell.nameTXT.text = "Me"
            cell.adminSW.hidden = true
            cell.adminTXT.hidden = true
            
        } else {
            
            cell.nameTXT.text = invitee.display_name
            cell.adminSW.hidden = false
            cell.adminTXT.hidden = false
            
        }
        
        if invitee.confirmed {
            
            cell.confirmedTXT.text = "CONFIRMED"
            cell.nameTXT.alpha = 1
            cell.confirmedTXT.alpha = 1
            
        } else {
            
            cell.confirmedTXT.text = "INVITED"
            cell.nameTXT.alpha = 0.5
            cell.confirmedTXT.alpha = 0.5
            
        }
        
        cell.adminSW.on = invitee.admin
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        let invitee = event.invited_list[indexPath.row]
        
        if invitee.user.objectId != currentUser.objectId && event.i_am_admin {
            
            return UITableViewCellEditingStyle.Delete
            
        } else {
            
            return UITableViewCellEditingStyle.None
            
        }
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        let invitee = event.invited_list[indexPath.row]
        let cell = tableView.cellForRowAtIndexPath(indexPath) as InviteeCell
        
        var actions: [UITableViewRowAction] = []
        
        var remove = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "REMOVE") { (a, i) -> Void in
            
            var alert = UIAlertController(title: "Confirm", message: "Are you sure you want to remove  from  ?", preferredStyle: UIAlertControllerStyle.Alert)
            
            var remove = UIAlertAction(title: "Remove", style: UIAlertActionStyle.Destructive, handler: { (a2) -> Void in
                
                cell.loader.startAnimating()
                
                self.event.invited.removeObject(invitee.user)
                
                self.event.save({ (s) -> Void in
                    
                    if s {
                        
                        self.event.removeInvited(invitee.user)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        
                    } else {
                        
                        self.event.invited.addObject(invitee.user)
                        
                    }
                    
                    self.refresh_event_delegate.refreshEvent(self.event)
                    
                    cell.loader.stopAnimating()
                    
                })
                
            })
            
            var cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (a2) -> Void in
                
                tableView.setEditing(false, animated: true)
                
            })
            
            alert.addAction(remove)
            alert.addAction(cancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        remove.backgroundColor = UIColor.redColor()
        
        if event.i_am_admin {
            
            actions.append(remove)
            
        }
        
        return actions
        
    }
    
    func refreshEvent(new_event: Event) {
        
        event = new_event
        
        setData()
        
    }

}
