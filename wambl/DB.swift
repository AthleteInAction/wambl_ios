class DB {
    
    // LOGIN
    // ========================================================================
    // ========================================================================
    class func login(username _username: String, password _password: String, completion: (s: Bool, error: NSError!) -> Void) {
        
        PFUser.logInWithUsernameInBackground(_username, password: _password) { (user: PFUser!, error: NSError!) -> Void in
            
            if !(error != nil) {
                
                currentUser = PFUser.currentUser()
                
            } else {
                
                var code = error.userInfo?["code"] as Int
                
                Error.report(user: nil, error: error, alert: true)
                
            }
            
            completion(s: !(error != nil), error: error)
            
        }
        
    }
    // ========================================================================
    // ========================================================================
    
    // SIGNUP
    // ========================================================================
    // ========================================================================
    class func signup(user _user: PFUser, completion: (s: Bool, e: NSError!) -> Void){
        
        _user.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            
            if !success {
                
                Error.report(user: nil, error: error, alert: true)
                
            }
            
            completion(s: success, e: error)
            
        }
        
    }
    // ========================================================================
    // ========================================================================
    
    // EVENTS
    // ========================================================================
    // ========================================================================
    class func getEvents(completion: (s: Bool, events: [Event]) -> Void){
    
        var admins_done = false
        var users_done = false
        
        var tmp_events: [Event] = []
        
        var invited_query = PFQuery(className: "Events")
        invited_query.whereKey("invited", containedIn: [currentUser])
        invited_query.whereKey("admins", notContainedIn: [currentUser])
        
        var admins_query = PFQuery(className: "Events")
        admins_query.whereKey("admins", containedIn: [currentUser])
        
        invited_query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil){
                
                for object in objects {
                    
                    var event = object as PFObject
                    
                    var tmp_event = Event(event: event)
                    
                    tmp_events.append(tmp_event)
                    
                }
                
            } else {
                
                Error.report(user: currentUser, error: error, alert: true)
                
            }
            
            users_done = true
            
            if admins_done {
                
                completion(s: !(error != nil), events: tmp_events)
                
            }
            
        }
        
        admins_query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if !(error != nil){
                
                for object in objects {
                    
                    var event = object as PFObject
                    
                    var tmp_event = Event(event: event)
                    
                    if tmp_event.creator.objectId == currentUser.objectId {
                        
                        tmp_event.i_am_admin = true
                        
                    }
                    
                    tmp_events.append(tmp_event)
                    
                }
                
            } else {
                
                Error.report(user: currentUser, error: error, alert: true)
                
            }
            
            admins_done = true
            
            if users_done {
                
                completion(s: !(error != nil), events: tmp_events)
                
            }
            
        }
    
    }
    // ========================================================================
    // ========================================================================
    
    class contacts {
        
        class func load(completion: (s: Bool,c: [Contact]) -> Void){
            
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
                    
                    Error.report(user: currentUser, error: error, alert: true)
                    
                }
                
                completion(s: !(error != nil),c: app_contacts)
                
            }
            
        }
        
    }
    
}