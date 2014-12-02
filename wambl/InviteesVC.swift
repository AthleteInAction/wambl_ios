//
//  InviteesVC.swift
//  wambl
//
//  Created by grobinson on 12/2/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class InviteesVC: UITableViewController {
    
    var event: Event!
    
    var rc: UIRefreshControl = UIRefreshControl()
    
    var invited: [Contact] = []
    var confirmed: [PFUser] = []
    var admins: [PFUser] = []
    
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
                
                self.invited.removeAll(keepCapacity: true)
                
                for invitee in c {
                    
                    self.invited.append(invitee)
                    
                }
                
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
        rc.endRefreshing()
        tableView.reloadData()
        
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        var invitee = invited[indexPath.row] as Contact
        
        if invitee.confirmed {
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
        }
        
        cell.textLabel.text = invitee.contact_full
        
        return cell
        
    }
    
    func checkConfirmed(){
        
        for i in 0..<invited.count {
            
            for c in confirmed {
                
                if c.username == invited[i].user.username {
                    
                    invited[i].confirmed = true
                    
                }
                
            }
            
        }
        
    }
    
    func invitePeople(){
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("new_event_add_people_vc") as NewEventAddPeopleVC
        vc.selected_contacts = invited
        vc.getAppContacts()
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

}
