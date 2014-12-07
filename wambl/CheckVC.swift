//
//  ViewController.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class CheckVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if currentUser != nil {
            
            // USER IS LOGGED IN
            self.performSegueWithIdentifier("events_from_check", sender: self)
            
        } else {
            
            // USER NOT LOGGED IN
            
            if account_info == "" {
                
                // NO USER ACCOUNT STORED
                self.performSegueWithIdentifier("signup_from_check", sender: self)
                
            } else {
                
                // USER ACCOUNT STORED
                DB.login(username: account_info, password: account_info, completion: { (s, error) -> Void in
                    
                    if s {
                        
                        currentUser = PFUser.currentUser()
                        self.performSegueWithIdentifier("events_from_check", sender: self)
                        
                    }
                    
                })
                
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }


}

