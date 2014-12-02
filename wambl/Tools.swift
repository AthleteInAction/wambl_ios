//
//  File.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import Foundation

class Tools {
    
    class func findContactByNumber(contacts: Array<Contact>,number: String) -> Contact {
        
        var contact: Contact = Contact()
        
        for c in contacts {
            
            if c.phone_number == number {
                
                contact = c
                
                break
                
            } else {
                
                contact.empty = true
                
            }
            
        }
        
        return contact
        
    }
    
    class func match(users: [PFUser],number: String) -> Bool {
        
        var clean = false
        
        for u in users {
            
            if u.username == number {
                
                clean = true
                
                break
                
            }
            
        }
        
        return clean
        
    }
    
}