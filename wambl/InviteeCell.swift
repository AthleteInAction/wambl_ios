
//
//  InviteeCell.swift
//  wambl
//
//  Created by grobinson on 12/7/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class InviteeCell: UITableViewCell {
    
    var refresh_event_delegate: RefreshEventPTC!
    
    var event: Event!
    
    var user: PFUser!

    @IBOutlet weak var nameTXT: UILabel!
    @IBOutlet weak var confirmedTXT: UILabel!
    @IBOutlet weak var adminTXT: UILabel!
    @IBOutlet weak var adminSW: UISwitch!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


        
    }

    @IBAction func adminCHG(sender: UISwitch) {
        
        if sender.on {
            
            event.admins.addObject(user)
            
        } else {
            
            event.admins.removeObject(user)
            
        }
        
        loader.startAnimating()
        
        event.save { (s) -> Void in
            
            if s {
                
                self.event.i_am_admin = sender.on
                
                if sender.on {
                    
                    self.event.addAdmin(self.user)
                    
                } else {
                    
                    self.event.removeAdmin(self.user)
                    
                }
                
            } else {
                
                sender.on = !sender.on
                
            }
            
            self.refresh_event_delegate.refreshEvent(self.event)
            
            self.loader.stopAnimating()
            
        }
        
    }
    
}
