//
//  EventDetailVC.swift
//  wambl
//
//  Created by grobinson on 12/1/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

protocol EventPTC {
    
    func refreshEvent(event: Event)
    
}

class EventDetailVC: UITableViewController, RefreshEventPTC {
    
    var refresh_event_delegate: RefreshEventPTC!
    
    var event: Event!
    
    var rc: UIRefreshControl = UIRefreshControl()
    
    var admin: Bool = true
    
    @IBOutlet weak var locTXT: UILabel!
    @IBOutlet weak var startTXT: UILabel!
    @IBOutlet weak var endTXT: UILabel!
    @IBOutlet weak var confirmedSW: UISwitch!
    @IBOutlet weak var confirmed_loader: UIActivityIndicatorView!
    
    @IBOutlet weak var invitees_loader: UIActivityIndicatorView!
    
    @IBOutlet weak var inviteesTXT: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rc.addTarget(self, action: "loadAll", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(rc)
        
    }
    
    func setData(){
        
        navigationItem.rightBarButtonItem = nil
        
        checkConfirmed()
        
        if event.invited_list.count == 0 {
            
            inviteesTXT.text = "Invitees"
            
        } else {
            
            inviteesTXT.text = "Invitees (\(event.invited_list.count))"
            
        }
        
        if event.i_am_admin {
            
            var editBTN = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editTPD")
            navigationItem.rightBarButtonItem = editBTN
            
        } else {
            
            navigationItem.rightBarButtonItem = nil
            
        }
        
        locTXT.text = event.location
        startTXT.text = Date.fullString(event.start_date)
        endTXT.text = Date.fullString(event.end_date)
        
        refresh_event_delegate.refreshEvent(event)
        
        rc.endRefreshing()
        
    }
    
    func editTPD(){
        
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("new_event_vc") as NewEventVC
        vc.event = event
        vc.existing = true
        vc.refresh_event_delegate = self
        
        var nav = UINavigationController(rootViewController: vc)
        
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func loadInvited(){
        
        invitees_loader.startAnimating()
        
        event.loadInvited { (s) -> Void in
            
            if s {
                
                self.setData()
                
            }
            
            self.invitees_loader.stopAnimating()
            
        }
        
    }
    
    func loadAdmins(){
        
        event.loadAdmins { (s) -> Void in
            
            if s {
                
                self.setData()
                
            }
            
        }
        
    }
    
    func loadConfirmed(){
        
        event.loadInvited { (s) -> Void in
            
            if s {
                
                self.setData()
                
            }
            
        }
        
    }
    
    func checkConfirmed(){
        
        for u in event.confirmed_list {
            
            if u.objectId == currentUser.objectId {
                
                event.i_am_confirmed = true
                break
                
            }
            
        }
        
        confirmedSW.on = event.i_am_confirmed
        
    }
    
    func loadAll(){
        
        var api_count = 0
        
        invitees_loader.startAnimating()
        
        event.loadInvited { (s) -> Void in
            
            if s {
                
                self.setData()
                
            }
            
            self.invitees_loader.stopAnimating()
            
            api_count++
            
            if api_count >= 3 {
                
                self.setAll()
                
            }
            
        }
        
        event.loadAdmins { (s) -> Void in
            
            if s {
                
                self.setData()
                
            }
            
            api_count++
            
            if api_count >= 3 {
                
                self.setAll()
                
            }
            
        }
        
        event.loadConfirmed { (s) -> Void in
            
            if s {
                
                self.setData()
                
            }
            
            api_count++
            
            if api_count >= 3 {
                
                self.setAll()
                
            }
            
        }
        
    }
    
    func setAll(){
        
        event.is_loaded = true
        setData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell?.reuseIdentifier == "invitee_cell" {
            
            var vc = storyboard?.instantiateViewControllerWithIdentifier("invitees_vc") as InviteesVC
            vc.event = event
            vc.refresh_event_delegate = self
            vc.loadView()
            vc.setData()
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return event.name
        case 2:
            return ""
        case 3:
            return ""
        default:
            return ""
        }
        
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return event.description
        default:
            return ""
        }
        
    }
    
    @IBAction func confirmedCHG(sender: UISwitch) {
        
        if sender.on {
            
            event.confirmed.addObject(currentUser)
            
        } else {
            
            event.confirmed.removeObject(currentUser)
            
        }
        
        confirmed_loader.startAnimating()
        
        event.save { (s) -> Void in
            
            if s {
                
                if sender.on {
                    
                    self.event.addConfirmed(currentUser)
                    self.event.i_am_confirmed = true
                    
                } else {
                    
                    self.event.removeConfirmed(currentUser)
                    self.event.i_am_confirmed = false
                    
                }
                
            } else {
                
                sender.on = !sender.on
                
            }
            
            self.refresh_event_delegate.refreshEvent(self.event)
            
            self.confirmed_loader.stopAnimating()
            
        }
        
    }
    
    func refreshEvent(new_event: Event){
        
        event = new_event
        
        tableView.reloadData()
        
        refresh_event_delegate.refreshEvent(new_event)
        
    }
    
}