//
//  AddInviteeVC.swift
//  wambl
//
//  Created by grobinson on 12/2/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class AddInviteeVC: UITableViewController {
    
    var invitees_delegate: InviteesPTC!
    var event_delegate: InviteesPTC!
    
    var event: Event!
    var invited: [Contact] = []
    var sorted_contacts: [String:[Contact]] = [
        "a": [Contact]()
    ]
    var sections: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Contacts"
        
        sorted_contacts.removeAll(keepCapacity: true)
        
        var cancelBTN = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelTPD")
        navigationItem.leftBarButtonItem = cancelBTN
        
        sortContacts()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return sorted_contacts.count
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var l = sections[section] as String
        var a = sorted_contacts[l]
        
        return a!.count
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var l = sections[section] as String
        
        return l.uppercaseString
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var l = sections[indexPath.section] as String
        var a: [Contact] = sorted_contacts[l]!
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        cell.textLabel.text = a[indexPath.row].contact_full
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var l = sections[indexPath.section] as String
        var c: Contact = sorted_contacts[l]![indexPath.row]
        inviteContact(c)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func sortContacts(){
        
        sorted_contacts.removeAll(keepCapacity: true)
        sections.removeAll(keepCapacity: true)
        
        var u: [PFUser] = []
        for i in invited {
            
            u.append(i.user)
            
        }
        
        for c in CONTACTS.contacts {
            
            if !Tools.match(u, number: c.phone_number) {
                
                var l = c.sort_name[0].lowercaseString
                l = l.stringByReplacingOccurrencesOfString("\\W", withString: "#", options: NSStringCompareOptions.RegularExpressionSearch, range: Range(start: l.startIndex, end: l.endIndex))
                
                if sorted_contacts[l] != nil {
                    
                    sorted_contacts[l]?.append(c)
                    sorted_contacts[l]?.sort({$0.sort_name < $1.sort_name})
                    
                } else {
                    
                    sorted_contacts[l] = [c]
                    sections.append(l)
                    
                }
                
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    func cancelTPD(){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func inviteContact(contact: Contact){
        
        navigationItem.title = "Inviting..."
        
        var r = event.object.relationForKey("invited") as PFRelation
        
        r.addObject(contact.user)
        
        event.object.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            
            if !(error != nil){
                
                self.invited.append(contact)
                
                self.invitees_delegate.refreshInvited(self.invited)
                self.event_delegate.refreshInvited(self.invited)
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                
                var code = error.userInfo?["code"] as Int
                var error_string = error.userInfo?["error"] as String
                Error.report(currentUser, code: code, error: error_string, alert: true, p: self)
                
            }
            
            self.navigationItem.title = "Contacts"
            
        }
        
    }
    
}
