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
        
        DB.login(username: user.username, password: user.username) { (s, error) -> Void in
            
            if s {
                
                self.loader.stopAnimating()
                
                currentUser = PFUser.currentUser()
                account_info = currentUser.username
                
                account_info.writeToFile(info_path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
                
                self.performSegueWithIdentifier("events_from_phone", sender: self)
                
            } else {
                
                var code = error.userInfo?["code"] as Int
                
                if code == 101 {
                    
                    self.signup()
                    
                } else {
                    
                    self.saveBTN.enabled = true
                    
                }
                
            }
            
        }
        
    }
    
    func signup(){
        
        DB.signup(user: user) { (s, e) -> Void in
            
            if s {
                
                self.loader.stopAnimating()
                
                currentUser = PFUser.currentUser()
                account_info = currentUser.username
                
                var error: NSError?
                account_info.writeToFile(info_path, atomically: true, encoding: NSUTF8StringEncoding, error: &error)
                
                self.performSegueWithIdentifier("events_from_phone", sender: self)
                
            } else {
                
                self.saveBTN.enabled = true
                
            }
            
        }
        
    }
    
}
