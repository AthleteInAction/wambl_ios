//
//  InviteeCell.swift
//  wambl
//
//  Created by grobinson on 12/3/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

protocol InviteeCellPTC {
    
    func removeAdmin(user: PFUser)
    func addAdmin(user: PFUser)
    func confirmAdmin(alert: UIAlertController)
    
}

class InviteeCell: UITableViewCell {
    
    var invitees_delegate: InviteeCellPTC!
    
    var event: Event!
    var invitee: Contact!
    var cell_index: Int!
    var index_path: NSIndexPath!
    
    @IBOutlet weak var adminSW: UISwitch!
    @IBOutlet weak var adminTXT: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var nameTXT: UILabel!
    @IBOutlet weak var confirmedTXT: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
        
    }

    @IBAction func adminCHG(sender: UISwitch) {
        
        var message = ""
        var m2 = ""
        var mstyle: UIAlertActionStyle!
        
        var r = event.object.relationForKey("admins") as PFRelation
        
        if sender.on {
            
            message = "Are you sure you want to give \(invitee.contact_full) admin privileges?"
            m2 = "Yes"
            mstyle = .Default
            r.addObject(invitee.user)
            
        } else {
            
            message = "Are you sure you want to revoke admin privileges from \(invitee.contact_full)?"
            m2 = "Revoke"
            mstyle = .Destructive
            r.removeObject(invitee.user)
            
        }
        
        var confirmAlert = UIAlertController(title: "Confirm", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        var okAction = UIAlertAction(title: m2, style: mstyle) { (a) -> Void in
            
            self.loader.startAnimating()
            
            self.event.object.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                
                if !(error != nil) {
                    
                    if sender.on {
                        
                        self.invitees_delegate.addAdmin(self.invitee.user)
                        
                    } else {
                        
                        self.invitees_delegate.removeAdmin(self.invitee.user)
                        
                    }
                    
                } else {
                    
                    var code = error.userInfo?["code"] as Int
                    var error_string = error.userInfo?["error"] as String
                    Error.report(currentUser, code: code, error: error_string, alert: true, p: self)
                    
                    sender.on = !sender.on
                    
                }
                
                self.loader.stopAnimating()
                
            }
            
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (a) -> Void in
            
            sender.on = !sender.on
            
        }
        
        confirmAlert.addAction(okAction)
        confirmAlert.addAction(cancelAction)
        
        invitees_delegate.confirmAdmin(confirmAlert)
        
    }
    
}
