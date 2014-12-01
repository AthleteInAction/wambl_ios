//
//  VerifyPhoneVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class VerifyPhoneVC: UIViewController, UITextFieldDelegate {
    
    var user: PFUser!
    
    @IBOutlet weak var phoneTXT: UITextField!
    @IBOutlet weak var saveBTN: UIBarButtonItem!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveBTN.enabled = false
        phoneTXT.delegate = self
        phoneTXT.addTarget(self, action: "phoneCHG", forControlEvents: .EditingChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    func phoneCHG(){
        
        if phoneTXT.text != "" {
            
            saveBTN.enabled = true
            
        } else {
            
            saveBTN.enabled = false
            
        }
        
    }

    @IBAction func saveTPD(sender: UIBarButtonItem) {
        
        if phoneTXT.text != "" {
            
            var phone = phoneTXT.text
            phone = phone.stringByReplacingOccurrencesOfString("\\D", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: Range(start: phone.startIndex, end: phone.endIndex))
            
            user.username = phone
            user.password = phone
            
            tryLogin()
            
        }
        
    }
    
    func tryLogin(){
        
        saveBTN.enabled = false
        loader.startAnimating()
        
        PFUser.logInWithUsernameInBackground(user.username, password: user.password) {
            (user: PFUser!, error: NSError!) -> Void in
            
            if user != nil {
                
                self.loader.stopAnimating()
                
                currentUser = PFUser.currentUser()
                account_info = currentUser.username
                
                account_info.writeToFile(info_path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                
                self.performSegueWithIdentifier("events_from_phone", sender: self)
                
            } else {
                
                var code = error.userInfo?["code"] as Int
                var error_string = error.userInfo?["error"] as String
                
                if code == 101 {
                    
                    self.signup()
                    
                } else {
                    
                    Error.report(nil, code: code, error: error_string,alert: true,p: self)
                    self.saveBTN.enabled = true
                    
                }
                
            }
            
        }
        
    }
    
    func signup(){
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            
            if !(error != nil) {
                
                self.loader.stopAnimating()
                
                currentUser = PFUser.currentUser()
                account_info = currentUser.username
                
                var error: NSError?
                account_info.writeToFile(info_path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
                
                self.performSegueWithIdentifier("events_from_phone", sender: self)
                
            } else {
                
                var code = error.userInfo?["code"] as Int
                var error_string = error.userInfo?["error"] as String
                
                Error.report(nil, code: code, error: error_string,alert: true,p: self)
                self.saveBTN.enabled = true
                
            }
            
            self.loader.stopAnimating()
            
        }
        
    }
    
}
