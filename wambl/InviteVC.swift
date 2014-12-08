//
//  InviteVC.swift
//  wambl
//
//  Created by Will Robinson on 12/7/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class InviteVC: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBAR: UISearchBar!
    var F: Bool = false
    
    var event: Event!
    
    var refresh_event_delegate: RefreshEventPTC!
    
    var fb: [String:[Contact]] = [
        "a": [Contact]()
    ]
    var f_sections: [String] = []
    var filtered_contacts: [Contact] = []
    
    var tb: [String:[Contact]] = [
        "a": [Contact]()
    ]
    var sections: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Invite"
        
        searchBAR.delegate = self
        
        tb.removeAll(keepCapacity: true)
        fb.removeAll(keepCapacity: true)
        
        var cancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelTPD")
        navigationItem.leftBarButtonItem = cancel
        
        organizeContacts()
        
    }
    
    func cancelTPD(){
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if F {
            
            return fb.count
            
        } else {
            
            return tb.count
            
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if F {
            
            var l = f_sections[section].lowercaseString as String
            var a = fb[l]
            
            return a!.count
            
        } else {
            
            var l = sections[section].lowercaseString as String
            var a = tb[l]
            
            return a!.count
            
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            
        }
        
        if F {
            
            var l = f_sections[indexPath.section].lowercaseString as String
            var a: [Contact] = fb[l]!
            var contact: Contact = a[indexPath.row]
            
            cell.textLabel.text = a[indexPath.row].contact_full
            
            if !contains(event.invited_list,{$0.phone_number == contact.phone_number}) {
                
                cell.textLabel.alpha = 1
                cell.userInteractionEnabled = true
                
            } else {
                
                cell.textLabel.alpha = 0.5
                cell.userInteractionEnabled = false
                
            }
            
        } else {
            
            var l = sections[indexPath.section].lowercaseString as String
            var a: [Contact] = tb[l]!
            var contact: Contact = a[indexPath.row]
            
            cell.textLabel.text = a[indexPath.row].contact_full
            
            if !contains(event.invited_list,{$0.phone_number == contact.phone_number}) {
                
                cell.textLabel.alpha = 1
                cell.userInteractionEnabled = true
                
            } else {
                
                cell.textLabel.alpha = 0.5
                cell.userInteractionEnabled = false
                
            }
            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if F {
            
            var l = f_sections[section] as String
            
            return l.uppercaseString
            
        } else {
            
            var l = sections[section] as String
            
            return l.uppercaseString
            
        }
        
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        
        if F {
            
            return f_sections
            
        } else {
            
            return sections
            
        }
        
    }
    
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        
        if F {
            
            if let index = find(f_sections,title.lowercaseString) {
                
                return index
                
            } else {
                
                return 0
                
            }
            
        } else {
            
            if let index = find(sections,title.lowercaseString) {
                
                return index
                
            } else {
                
                return 0
                
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var contact: Contact!
        
        if F {
            
            let l = f_sections[indexPath.section].lowercaseString
            let s = fb[l]!
            contact = s[indexPath.row] as Contact
            
        } else {
            
            let l = sections[indexPath.section].lowercaseString
            let s = tb[l]!
            contact = s[indexPath.row] as Contact
            
        }
        
        self.title = "Inviting..."
        
        event.invited.addObject(contact.user)
        
        event.save { (s) -> Void in
            
            if s {
                
                self.event.addInvited(contact)
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                
                self.event.invited.removeObject(contact.user)
                
            }
            
            self.refresh_event_delegate.refreshEvent(self.event)
            
            self.title = "Invite"
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if countElements(searchText) == 0 {
            
            F = false
            
            organizeContacts()
            
        } else {
            
            F = true
            
            filtered_contacts.removeAll(keepCapacity: true)
            
            for c in CONTACTS.contacts {
                
                if (c.first_name.lowercaseString as NSString).rangeOfString(searchText.lowercaseString).length != 0 ||
                    (c.last_name.lowercaseString as NSString).rangeOfString(searchText.lowercaseString).length != 0 {
                        
                        filtered_contacts.append(c)
                        
                }
                
            }
            
            organizeFiltered()
            
        }
        
    }
    
    func organizeFiltered(){
        
        fb.removeAll(keepCapacity: true)
        f_sections.removeAll(keepCapacity: true)
        
        for c in filtered_contacts {
            
            var l = c.sort_name[0].lowercaseString
            l = l.stringByReplacingOccurrencesOfString("\\W", withString: "#", options: NSStringCompareOptions.RegularExpressionSearch, range: Range(start: l.startIndex, end: l.endIndex))
            
            if fb[l] != nil {
                
                fb[l]?.append(c)
                fb[l]?.sort({$0.sort_name < $1.sort_name})
                
            } else {
                
                fb[l] = [c]
                f_sections.append(l.uppercaseString)
                
            }
            
        }
        
        f_sections.sort({$0 < $1})
        
        tableView.reloadData()
        
    }
    
    func organizeContacts(){
        
        tb.removeAll(keepCapacity: true)
        sections.removeAll(keepCapacity: true)
        
        for c in CONTACTS.contacts {
            
            var l = c.sort_name[0].lowercaseString
            l = l.stringByReplacingOccurrencesOfString("\\W", withString: "#", options: NSStringCompareOptions.RegularExpressionSearch, range: Range(start: l.startIndex, end: l.endIndex))
            
            if tb[l] != nil {
                
                tb[l]?.append(c)
                tb[l]?.sort({$0.sort_name < $1.sort_name})
                
            } else {
                
                tb[l] = [c]
                sections.append(l.uppercaseString)
                
            }
            
        }
        
        sections.sort({$0 < $1})
        
        tableView.reloadData()
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        tableView.endEditing(true)
        
    }

}
