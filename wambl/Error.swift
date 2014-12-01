class Error {
    
    class func report(user: PFUser?,code: Int,error: String,alert: Bool,p: UIViewController){
        
        var pf_error = PFObject(className: "Errors")
        
        if user != nil {
            pf_error["user"] = user
        }
        
        pf_error["code"] = code
        pf_error["error"] = error
        
        pf_error.saveInBackgroundWithBlock({ (success: Bool, lerror: NSError!) -> Void in
            
            if success {
                
                NSLog("Error Reported")
                if alert {
                    
                    // ALERT USER TO ERROR
                    var errorAlert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.Alert)
                    
                    errorAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                        
                        
                        
                    }))
                    
                    p.presentViewController(errorAlert, animated: true, completion: nil)
                    
                }
                
            } else {
                
                NSLog("Report Error")
                
            }
            
        })
        
    }
    
}