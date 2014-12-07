//
//  InviteesVC.swift
//  wambl
//
//  Created by grobinson on 12/7/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class InviteesVC: UITableViewController {
    
    var refresh_event_delegate: RefreshEventPTC!
    
    var event: Event!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    func setData(){
        
        checkAdmins()
        checkConfirmed()
        
        event.i_am_creator = (event.creator.objectId == currentUser.objectId)
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as InviteeCell
        cell.event = event
        cell.refresh_event_delegate = refresh_event_delegate
        
        let invitee = event.invited_list[indexPath.row]
        
        cell.user = invitee.user
        
        cell.nameTXT.text = invitee.display_name
        
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
        
        if invitee.user.objectId == currentUser.objectId {
            
            cell.adminSW.hidden = true
            cell.adminTXT.hidden = true
            
        } else {
            
            cell.adminSW.hidden = false
            cell.adminTXT.hidden = false
            
        }
        
        return cell
        
    }

}
