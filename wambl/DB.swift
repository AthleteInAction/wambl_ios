class DB {
    
    // EVENTS
    // ========================================================================
    // ========================================================================
    class event {
        
        // LOAD AN EVENT
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        class func load(event: PFObject,view: AnyObject, completion: (s: Bool,e: PFObject) -> Void) {
            
            var query = PFQuery(className: "Events")
            
            query.getObjectInBackgroundWithId(event.objectId, block: { (object: PFObject!, error: NSError!) -> Void in
                
                var s: Bool!
                var e: PFObject!
                
                if !(error != nil){
                    
                    s = true
                    e = object
                    
                } else {
                    
                    s = false
                    
                    var code = error.userInfo?["code"] as Int
                    var error_string = error.userInfo?["error"] as String
                    Error.report(currentUser, code: code, error: error_string, alert: true, p: view)
                    
                }
                
                completion(s: s, e: e)
                
            })
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // INVITED USERS
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        class invited {
            
            class func load(event: PFObject,view: AnyObject, completion: (s: Bool,c: [Contact]) -> Void) {
                
                var relation = event["invited"] as PFRelation
                
                var contacts = Contacts.getContacts()!
                
                relation.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                    
                    var s: Bool!
                    var c: [Contact] = []
                    
                    if !(error != nil){
                        
                        s = true
                        
                        for o in objects {
                            
                            var user = o as PFUser
                            
                            var tmp_contact = Tools.findContactByNumber(contacts, number: user.username) as Contact
                            var new_contact = Contact()
                            
                            if tmp_contact.empty {
                                
                                new_contact.display_name = user["name"] as String
                                new_contact.contact_full = user["name"] as String
                                new_contact.phone_number = user.username
                                
                            } else {
                                
                                new_contact = tmp_contact
                                
                            }
                            
                            new_contact.user = user
                            
                            c.append(new_contact)
                            
                        }
                        
                        
                    } else {
                        
                        s = false
                        
                        var code = error.userInfo?["code"] as Int
                        var error_string = error.userInfo?["error"] as String
                        Error.report(currentUser, code: code, error: error_string, alert: true, p: view)
                        
                    }
                    
                    completion(s: s, c: c)
                    
                }
                
            }
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // CONFIRMED USERS
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        class confirmed {
            
            class func load(event: PFObject,view: AnyObject, completion: (s: Bool,u: [PFUser]) -> Void) {
                
                var relation = event["confirmed"] as PFRelation
                
                relation.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                    
                    var s: Bool!
                    var u: [PFUser] = []
                    
                    if !(error != nil){
                        
                        s = true
                        
                        for o in objects {
                            
                            var user = o as PFUser
                            u.append(user)
                            
                        }
                        
                        
                    } else {
                        
                        s = false
                        
                        var code = error.userInfo?["code"] as Int
                        var error_string = error.userInfo?["error"] as String
                        Error.report(currentUser, code: code, error: error_string, alert: true, p: view)
                        
                    }
                    
                    completion(s: s, u: u)
                    
                }
                
            }
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // ADMIN USERS
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        class admins {
            
            class func load(event: PFObject,view: AnyObject, completion: (s: Bool,u: [PFUser]) -> Void) {
                
                var relation = event["admins"] as PFRelation
                
                relation.query().findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                    
                    var s: Bool!
                    var u: [PFUser] = []
                    
                    if !(error != nil){
                        
                        s = true
                        
                        for o in objects {
                            
                            var user = o as PFUser
                            u.append(user)
                            
                        }
                        
                        
                    } else {
                        
                        s = false
                        
                        var code = error.userInfo?["code"] as Int
                        var error_string = error.userInfo?["error"] as String
                        Error.report(currentUser, code: code, error: error_string, alert: true, p: view)
                        
                    }
                    
                    completion(s: s, u: u)
                    
                }
                
            }
            
        }
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
    }
    // ========================================================================
    // ========================================================================
    
    class contacts {
        
        class func load(view: AnyObject,completion: (s: Bool,c: [Contact]) -> Void){
            
            var s: Bool!
            
            var phone_contacts = Contacts.getContacts()!
            var app_contacts: [Contact] = []
            
            var list: [String] = []
            
            for c in phone_contacts {
                
                list.append("'\(c.phone_number)'")
                
            }
            
            var query_string = ",".join(list)
            
            var pred = NSPredicate(format:"username IN {\(query_string)}")
            var query = PFQuery(className: "_User", predicate: pred)
            
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
                
                if !(error != nil){
                    
                    s = true
                    
                    for object in objects {
                        
                        var user = object as PFUser
                        
                        var c: Contact = Tools.findContactByNumber(phone_contacts, number: user.username)
                        
                        if !c.empty {
                            
                            c.user = user
                            c.db_name = user["name"] as String
                            app_contacts.append(c)
                            
                        }
                        
                    }
                    
                } else {
                    
                    s = false
                    
                    var code = error.userInfo?["code"] as Int
                    var error_string = error.userInfo?["error"] as String
                    Error.report(currentUser, code: code, error: error_string, alert: true, p: view)
                    
                }
                
                completion(s: s,c: app_contacts)
                
            }
            
        }
        
    }
    
}