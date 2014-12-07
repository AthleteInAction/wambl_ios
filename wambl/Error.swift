class Error {
    
    class func report(user _user: PFUser?,error _error: NSError, alert _alert: Bool){
        
        var pf_error = PFObject(className: "Errors")
        
        if _user != nil {
            pf_error["user"] = _user
        }
        
        var code: Int = _error.userInfo?["code"] as Int
        var error_string: String = _error.userInfo?["error"] as String
        
        pf_error["code"] = code
        pf_error["error"] = error_string
        
        pf_error.saveInBackgroundWithBlock({ (success: Bool, lerror: NSError!) -> Void in
            
            if success {
                
                NSLog("Error Reported")
                if _alert {
                    
                    // ALERT USER TO ERROR
                    var errorAlert = UIAlertController(title: "Error", message: error_string, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        
                        
                        
                    }))
                    
                    root.rootViewController?.presentViewController(errorAlert, animated: true, completion: nil)
                    
                }
                
            } else {
                
                NSLog("Report Error")
                
            }
            
        })
        
    }
    
}