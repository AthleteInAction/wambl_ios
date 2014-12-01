//
//  NewEventAddPeopleVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class NewEventAddPeopleVC: UITableViewController, UISearchBarDelegate {
    
    var new_event: PFObject!
    
    var phone_contacts: [Contact] = []
    var selected_contacts: [Contact] = []
    var app_contacts: [Contact] = []
    var filtered_contacts: [Contact] = []
    
    @IBOutlet weak var saveBTN: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchDisplayController?.searchResultsTableView.delegate = self
        
        saveBTN.enabled = false
        
        phone_contacts = Contacts.getContacts()!
        
        getAppContacts()
        
    }
    
    func getAppContacts(){
        
        var list: [String] = []
        
        for c in phone_contacts {
            
            list.append("'\(c.phone_number)'")
            
        }
        
        var query_string = ",".join(list)
        
        var pred = NSPredicate(format:"username IN {\(query_string)}")
        var query = PFQuery(className: "_User", predicate: pred)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil){
                
                for object in objects {
                    
                    var user = object as PFUser
                    
                    var c: Contact = Tools.findContactByNumber(self.phone_contacts, number: user.username)
                    
                    if !c.empty {
                        
                        c.user = user
                        c.db_name = user["name"] as String
                        self.app_contacts.append(c)
                        
                    }
                    
                }
                
            } else {
                
                
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if tableView == searchDisplayController?.searchResultsTableView {
            
            return 1
            
        } else {
            
            return 1
            
        }
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchDisplayController?.searchResultsTableView {
            
            return filtered_contacts.count
            
        } else {
            
            return selected_contacts.count
            
        }
        
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            
        }
        
        if tableView == searchDisplayController?.searchResultsTableView {
            
            cell.textLabel.text = "\(filtered_contacts[indexPath.row].contact_full)"
            
        } else {
            
            cell.textLabel.text = "\(selected_contacts[indexPath.row].contact_full)"
            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if tableView == searchDisplayController?.searchResultsTableView {
            
            selected_contacts.append(filtered_contacts[indexPath.row])
            self.tableView.reloadData()
            searchDisplayController?.setActive(false, animated: false)
            
        } else {
            
            
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
        
        
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered_contacts.removeAll(keepCapacity: true)
        
        for c in app_contacts {
            
            var clean = true
            for b in selected_contacts {
                
                if b.phone_number == c.phone_number {
                    
                    clean = false
                    
                }
                
            }
            
            if clean {
                
                if (c.first_name.lowercaseString as NSString).rangeOfString(searchText.lowercaseString).length != 0 ||
                    (c.last_name.lowercaseString as NSString).rangeOfString(searchText.lowercaseString).length != 0 {
                        
                        filtered_contacts.append(c)
                        println(c.display_name)
                        
                }
                
            }
            
        }
        
    }
    
}
