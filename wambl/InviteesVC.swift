//
//  InviteesVC.swift
//  wambl
//
//  Created by grobinson on 12/2/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

protocol InviteesPTC {
    
    func refreshInvited(new_invited: [Contact])
    
}

protocol InviteesAdminsPTC {
    
    func refreshAdmins(new_admins: [PFUser])
    
}

class InviteesVC: UITableViewController, InviteesPTC, InviteeCellPTC {
    
    var event_delegate: InviteesPTC!
    var event_admins_delegate: InviteesAdminsPTC!
    
    var event: Event!
    
    var rc: UIRefreshControl = UIRefreshControl()
    
    var invited: [Contact] = []
    var confirmed: [PFUser] = []
    var admins: [PFUser] = []
    
    var i_am_confirmed: Bool!
    
    var admin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rc.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(rc)
        
    }
    
    func loadData(){
        
        var api_count = 0
        
        DB.event.invited.load(self.event.object, view: self) { (s, c) -> Void in
            
            if s {
                
                self.invited = c
                
            }
            
            api_count++
            
            if api_count >= 3 {
                
                self.setData()
                
            }
            
        }
        
        DB.event.confirmed.load(self.event.object, view: self) { (s, u) -> Void in
            
            if s {
                
                self.confirmed.removeAll(keepCapacity: true)
                
                for user in u {
                    
                    self.confirmed.append(user)
                    
                }
                
            }
            
            api_count++
            
            if api_count >= 3 {
                
                self.setData()
                
            }
            
        }
        
        DB.event.admins.load(self.event.object, view: self) { (s, u) -> Void in
            
            if s {
                
                self.admins.removeAll(keepCapacity: true)
                
                for user in u {
                    
                    self.admins.append(user)
                    
                }
                
            }
            
            api_count++
            
            if api_count >= 3 {
                
                self.setData()
                
            }
            
        }
        
    }
    
    func setData(){
        
        var addBTN = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "invitePeople")
        
        if Tools.match(admins, number: currentUser.username) {
            
            admin = true
            navigationItem.rightBarButtonItems = [addBTN]
            
        } else {
            
            admin = false
            navigationItem.rightBarButtonItems = []
            
        }
        
        checkConfirmed()
        checkAdmin()
        
        rc.endRefreshing()
        
        invited.sort({$0.contact_full < $1.contact_full})
        
        tableView.reloadData()
        
        event_delegate.refreshInvited(invited)
        event_admins_delegate.refreshAdmins(admins)
        
    }
    
    func refreshInvited(new_invited: [Contact]) {
        
        invited = new_invited
        setData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return invited.count
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        
        var invitee = invited[indexPath.row] as Contact
        var cell = tableView.cellForRowAtIndexPath(indexPath) as InviteeCell
        
        var removeAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remove") { (a,i) -> Void in
            
            var confirmAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to remove ?", preferredStyle: UIAlertControllerStyle.Alert)
            
            confirmAlert.addAction(UIAlertAction(title: "Remove", style: UIAlertActionStyle.Destructive, handler: { (a) -> Void in
                
                var i_invited = self.event.object.relationForKey("invited") as PFRelation
                i_invited.removeObject(invitee.user)
                
                var a_invited = self.event.object.relationForKey("admins") as PFRelation
                a_invited.removeObject(invitee.user)
                
                var c_invited = self.event.object.relationForKey("confirmed") as PFRelation
                c_invited.removeObject(invitee.user)
                
                cell.loader.startAnimating()
                
                self.event.object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) -> Void in
                    
                    if !(error != nil) {
                        
                        self.invited.removeAtIndex(indexPath.row)
                        self.event_delegate.refreshInvited(self.invited)
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        
                    } else {
                        
                        let code = error.userInfo?["code"] as Int
                        let error_string = error.userInfo?["error"] as String
                        Error.report(currentUser, code: code, error: error_string, alert: true, p: self)
                        
                    }
                    
                    cell.loader.stopAnimating()
                    
                    tableView.setEditing(false, animated: true)
                    
                })
                
            }))
            
            confirmAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (a) -> Void in
                
                tableView.setEditing(false, animated: true)
                
            }))
            
            self.presentViewController(confirmAlert, animated: true, completion: nil)
            
        }
        
        return [removeAction]
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as InviteeCell
        
        var invitee = invited[indexPath.row] as Contact
        
        cell.invitees_delegate = self
        cell.event = event
        cell.invitee = invitee
        cell.cell_index = indexPath.row
        
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
        
        if invitee.user.username == currentUser.username {
            
            cell.adminSW.hidden = true
            cell.adminTXT.hidden = true
            
        }
        
        cell.nameTXT.text = invitee.contact_full
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        
        var invitee = invited[indexPath.row] as Contact
        
        if invitee.user.username == currentUser.username {
            
            return UITableViewCellEditingStyle.None
            
        } else {
            
            return UITableViewCellEditingStyle.Delete
            
        }
        
    }
    
    func checkConfirmed(){
        
        for i in 0..<invited.count {
            
            var x: Bool = false
            
            for c in confirmed {
                
                if c.username == invited[i].user.username {
                    
                    x = true
                    
                    break
                    
                }
                
            }
            
            if x {
                invited[i].confirmed = true
            } else {
                invited[i].confirmed = false
            }
            
        }
        
    }
    
    func checkAdmin(){
        
        for i in 0..<invited.count {
            
            var x: Bool = false
            
            for c in admins {
                
                if c.username == invited[i].user.username {
                    
                    x = true
                    
                    break
                    
                }
                
            }
            
            if x {
                invited[i].admin = true
            } else {
                invited[i].admin = false
            }
            
        }
        
    }
    
    func invitePeople(){
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("add_invitee_vc") as AddInviteeVC
        vc.invited = invited
        vc.event = event
        vc.invitees_delegate = self
        vc.event_delegate = event_delegate
        var nav = UINavigationController(rootViewController: vc)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func addAdmin(user: PFUser) {
        
        admins.append(user)
        
        setData()
        
    }
    
    func removeAdmin(user: PFUser) {
        
        for i in 0..<countElements(admins) {
            
            if admins[i].username == user.username {
                
                admins.removeAtIndex(i)
                
                break
                
            }
            
        }
        
        setData()
        
    }
    
    func confirmAdmin(alert: UIAlertController) {
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}
