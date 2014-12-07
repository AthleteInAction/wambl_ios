//
//  NewEventAddPeopleVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

protocol AddEventPTC {
    
    func addEvent(event: Event)
    
}

class NewEventAddPeopleVC: UITableViewController, UISearchBarDelegate {
    
    var events_delegate: AddEventPTC!
    
    var event: Event!
    var existing: Bool = false
    
    var phone_contacts: [Contact] = []
    var selected_contacts: [Contact] = []
    var filtered_contacts: [Contact] = []
    
    @IBOutlet weak var saveBTN: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchDisplayController?.searchResultsTableView.delegate = self
        
        saveBTN.enabled = false
        
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
            cell.selectionStyle = .None
            
        }
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if tableView == searchDisplayController?.searchResultsTableView {
            
            selected_contacts.append(filtered_contacts[indexPath.row])
            self.tableView.reloadData()
            searchDisplayController?.setActive(false, animated: false)
            if selected_contacts.count == 0 {
                saveBTN.enabled = false
            } else {
                saveBTN.enabled = true
            }
            
        } else {
            
            
            
        }
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if tableView == searchDisplayController?.searchResultsTableView {
            
            
            
        } else {
            
            if editingStyle == .Delete {
                
                selected_contacts.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                if selected_contacts.count == 0 {
                    saveBTN.enabled = false
                } else {
                    saveBTN.enabled = true
                }
                
            }
            
        }
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
        
        
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered_contacts.removeAll(keepCapacity: true)
        
        for c in CONTACTS.contacts {
            
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
                        
                }
                
            }
            
        }
        
    }
    
    @IBAction func saveTPD(sender: AnyObject) {
        
        navigationItem.title = "Creating..."
        saveBTN.enabled = false
        
        event.admins.addObject(currentUser)
        event.invited.addObject(currentUser)
        
        for c in selected_contacts {
            
            event.invited.addObject(c.user)
            
        }
        
        event.save { (s) -> Void in
            
            if s {
                
                self.events_delegate.addEvent(self.event)
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                
                self.saveBTN.enabled = true
                
            }
            
        }
        
    }
    
}
