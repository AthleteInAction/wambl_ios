//
//  Event.swift
//  wambl
//
//  Created by grobinson on 12/1/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import Foundation

class Event {
    
    var parse: PFObject!
    
    var i_am_admin: Bool = false
    var i_am_creator: Bool = false
    var i_am_confirmed: Bool = false
    
    var creator: PFUser!
    var name: String!
    var description: String!
    var start_date: NSDate!
    var end_date: NSDate!
    var location: String!
    var invited: PFRelation!
    var invited_list: [Contact] = []
    var admins: PFRelation!
    var admins_list: [PFUser] = []
    var confirmed: PFRelation!
    var confirmed_list: [PFUser] = []
    
    var is_loaded: Bool = false
    
    init(event: PFObject?){
        
        if event != nil {
            
            parse = event
            
            admins = parse.relationForKey("admins") as PFRelation
            invited = parse.relationForKey("invited") as PFRelation
            confirmed = parse.relationForKey("confirmed") as PFRelation
            
            creator = event?["creator"] as PFUser
            
            name = parse["name"] as String
            description = parse["description"] as String
            start_date = parse["start_date"] as NSDate
            end_date = parse["end_date"] as NSDate
            location = parse["location"] as String
            
        } else {
            
            parse = PFObject(className: "Events")
            
            admins = parse.relationForKey("admins") as PFRelation
            admins.addObject(currentUser)
            
            invited = parse.relationForKey("invited") as PFRelation
            invited.addObject(currentUser)
            
            confirmed = parse.relationForKey("confirmed") as PFRelation
            
            creator = currentUser
            
        }
        
        i_am_creator = (currentUser.objectId == creator.objectId)
        
    }
    
    private func setObject(){
        
        parse["creator"] = creator
        parse["name"] = name
        parse["location"] = location
        parse["description"] = description
        parse["start_date"] = start_date
        parse["end_date"] = end_date
        
    }
    
    func save(completion: (s: Bool) -> Void){
        
        setObject()
        
        parse.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            
            if !success {
                
                println("SAVE ERROR")
                Error.report(user: currentUser, error: error, alert: true)
                
            }
            
            self.setStatus()
            
            completion(s: success)
            
        }
        
    }
    
    func delete(completion: (s: Bool) -> Void){
        
        parse.deleteInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            
            if !success {
                
                NSLog("ERROR")
                Error.report(user: currentUser, error: error, alert: true)
                
            }
            
            self.setStatus()
            
            completion(s: success)
            
        }
        
    }
    
    func loadInvited(completion: (s: Bool) -> Void){
        
        invited.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil){
                
                self.invited_list = []
                
                for o in objects {
                    
                    var user = o as PFUser
                    
                    var c = Tools.findContactByNumber(CONTACTS.contacts, number: user.username)
                    
                    if c.empty {
                        
                        c.display_name = user["name"] as String
                        c.contact_full = user["name"] as String
                        
                    }
                    
                    c.user = user
                    
                    self.invited_list.append(c)
                    
                }
                
            } else {
                
                Error.report(user: currentUser, error: error, alert: true)
                
            }
            
            self.setStatus()
            
            completion(s: !(error != nil))
            
        }
        
    }
    
    func loadConfirmed(completion: (s: Bool) -> Void){
        
        confirmed.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil){
                
                self.confirmed_list = []
                
                for o in objects {
                    
                    var user = o as PFUser
                    
                    self.confirmed_list.append(user)
                    
                }
                
            } else {
                
                Error.report(user: currentUser, error: error, alert: true)
                
            }
            
            self.setStatus()
            
            completion(s: !(error != nil))
            
        }
        
    }
    
    func loadAdmins(completion: (s: Bool) -> Void){
        
        admins.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil){
                
                self.admins_list = []
                
                for o in objects {
                    
                    var user = o as PFUser
                    
                    self.admins_list.append(user)
                    
                }
                
            } else {
                
                Error.report(user: currentUser, error: error, alert: true)
                
            }
            
            self.setStatus()
            
            completion(s: !(error != nil))
            
        }
        
    }
    
    func addInvited(contact: Contact){
        
        invited_list.append(contact)
        self.setStatus()
        
    }
    
    func removeInvited(user: PFUser){
        
        for i in 0..<countElements(invited_list) {
            
            if invited_list[i].user.objectId == user.objectId {
                
                invited_list.removeAtIndex(i)
                break
                
            }
            
        }
        
        self.setStatus()
        
    }
    
    func addConfirmed(user: PFUser){
        
        confirmed_list.append(user)
        self.setStatus()
        
    }
    
    func removeConfirmed(user: PFUser){
        
        for i in 0..<countElements(confirmed_list) {
            
            if confirmed_list[i].objectId == user.objectId {
                
                confirmed_list.removeAtIndex(i)
                break
                
            }
            
        }
        
        self.setStatus()
        
    }
    
    func addAdmin(user: PFUser){
        
        admins_list.append(user)
        self.setStatus()
        
    }
    
    func removeAdmin(user: PFUser){
        
        for i in 0..<countElements(admins_list) {
            
            if admins_list[i].objectId == user.objectId {
                
                admins_list.removeAtIndex(i)
                break
                
            }
            
        }
        
        self.setStatus()
        
    }
    
    func isInvited(user: PFUser) -> Bool {
        
        var found: Bool = false
        
        for c in invited_list {
            
            if c.user.objectId == user.objectId {
                
                found = true
                break
                
            }
            
        }
        
        return found
        
    }
    
    func isAdmin(user: PFUser) -> Bool {
        
        var found: Bool = false
        
        for u in admins_list {
            
            if u.objectId == user.objectId {
                
                found = true
                break
                
            }
            
        }
        
        return found
        
    }
    
    func isConfirmed(user: PFUser) -> Bool {
        
        var found: Bool = false
        
        for u in confirmed_list {
            
            if u.objectId == user.objectId {
                
                found = true
                break
                
            }
            
        }
        
        return found
        
    }
    
    func setStatus(){
        
        for i in 0..<countElements(invited_list) {
            
            invited_list[i].creator = (creator.objectId == invited_list[i].user.objectId)
            invited_list[i].admin = isAdmin(invited_list[i].user)
            invited_list[i].confirmed = isConfirmed(invited_list[i].user)
            
        }
        
    }
    
}