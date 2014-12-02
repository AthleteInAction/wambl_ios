//
//  EventDetailVC.swift
//  wambl
//
//  Created by grobinson on 12/1/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class EventDetailVC: UITableViewController {
    
    var event: Event!
    
    var rc: UIRefreshControl!
    
    var phone_contacts: [Contact]!
    var invited: [Contact] = []
    var confirmed: [PFUser] = []
    var admins: [PFUser] = []
    
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
        
        rc = UIRefreshControl()
        rc.addTarget(self, action: "loadEvent", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(rc)
        
    }
    
    func setData(){
        
        if Tools.match(admins, number: currentUser.username) {
            
            admin = true
            
        } else {
            
            admin = false
            
        }
        
        if Tools.match(confirmed, number: currentUser.username) {
            
            confirmedSW.on = true
            
        } else {
            
            confirmedSW.on = false
            
        }
        
        if invited.count == 0 {
            
            inviteesTXT.text = "Invitees"
            
        } else {
            
            inviteesTXT.text = "Invitees (\(invited.count))"
            
        }
        
        locTXT.text = event.object["location"] as? String
        startTXT.text = Date.fullString((event.object["start_date"] as NSDate))
        endTXT.text = Date.fullString((event.object["end_date"] as NSDate))
        
        rc.endRefreshing()
        tableView.reloadData()
        
    }
    
    func loadEvent(){
        
        var api_count = 0
        
        DB.event.load(self.event.object, view: self) { (s, e) -> Void in
            
            if s {
                
                self.event.object = e as PFObject
                
            }
            
            api_count++
            
            if api_count >= 4 {
                
                self.setData()
                
            }
            
        }
        
        DB.event.invited.load(self.event.object, view: self) { (s, c) -> Void in
            
            if s {
                
                self.invited.removeAll(keepCapacity: true)
                
                for invitee in c {
                    
                    self.invited.append(invitee)
                    
                }
                
            }
            
            api_count++
            
            if api_count >= 4 {
                
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
            
            if api_count >= 4 {
                
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
            
            if api_count >= 4 {
                
                self.setData()
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell?.reuseIdentifier == "invitees_cell" {
            
            var vc = storyboard?.instantiateViewControllerWithIdentifier("invitees_vc") as InviteesVC
            vc.event = event
            vc.invited = invited
            vc.confirmed = confirmed
            vc.admins = admins
            vc.admin = admin
            vc.setData()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return event.object["name"] as? String
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
            return event.object["description"] as? String
        default:
            return ""
        }
        
    }
    
    @IBAction func confirmedCHG(sender: UISwitch) {
        
        var confirmed_relation = event.object["confirmed"] as PFRelation
        
        if sender.on {
            
            confirmed_relation.addObject(currentUser)
            
        } else {
            
            confirmed_relation.removeObject(currentUser)
            
        }
        
        confirmed_loader.startAnimating()
        
        event.object.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            
            if success {
                
                
                
            } else {
                
                var code = error.userInfo?["code"] as Int
                var error_string = error.userInfo?["error"] as String
                Error.report(currentUser, code: code, error: error_string, alert: true, p: self)
                
            }
            
            self.confirmed_loader.stopAnimating()
            
        }
        
    }
    
}