//
//  SignupNameVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class SignupNameVC: UIViewController, UITextFieldDelegate {
    
    var user: PFUser = PFUser()
    
    @IBOutlet weak var nameTXT: UITextField!
    @IBOutlet weak var nextBTN: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBTN.enabled = false

        nameTXT.delegate = self
        nameTXT.addTarget(self, action: "nameCHG", forControlEvents: .EditingChanged)
        
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
    
    func nameCHG(){
        
        if nameTXT.text != "" {
            
            nextBTN.enabled = true
            
        } else {
            
            nextBTN.enabled = false
            
        }
        
    }
    
    @IBAction func nextTPD(sender: UIBarButtonItem) {
        
        if nameTXT.text != "" {
            
            user["name"] = nameTXT.text
            self.performSegueWithIdentifier("phone_from_name", sender: self)
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "phone_from_name" {
            
            var vc = segue.destinationViewController as VerifyPhoneVC
            vc.user = user
            
        }
        
    }

}
