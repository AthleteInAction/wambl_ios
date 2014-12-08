//
//  NewEventVC.swift
//  wambl
//
//  Created by Will Robinson on 11/30/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class NewEventVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var event: Event = Event(event: nil)
    
    var events_delegate: AddEventPTC!
    
    var refresh_event_delegate: RefreshEventPTC!
    
    var existing: Bool = false
    
    @IBOutlet weak var nameTXT: UITextField!
    @IBOutlet weak var locTXT: UITextField!
    @IBOutlet weak var descTXT: UITextView!
    @IBOutlet weak var nextBTN: UIBarButtonItem!
    
    var placeholder: String = "Description"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if existing {
            
            navigationItem.title = "Edit Event"
            
        }
        
        descTXT.layer.borderColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1).CGColor
        descTXT.textColor = nameTXT.textColor
        descTXT.delegate = self
        nameTXT.delegate = self
        locTXT.delegate = self
        
        if (descTXT.text == "") {
            textViewDidEndEditing(descTXT)
        }
        
        nameTXT.addTarget(self, action: "checkClean", forControlEvents: .EditingChanged)
        locTXT.addTarget(self, action: "checkClean", forControlEvents: .EditingChanged)
        
    }
    
    func setData(){
        
        if existing {
            
            nameTXT.text = event.name
            locTXT.text = event.location
            descTXT.text = event.description
            
        }
        
        checkClean()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        setData()
        
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
    
    func textViewDidChange(textView: UITextView) {
        
        checkClean()
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
        if (textView.text == "") {
            textView.text = placeholder
            textView.textColor = UIColor(red: 0.80, green: 0.80, blue: 0.80, alpha: 1)
        }
        textView.resignFirstResponder()
        
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        
        if (textView.text == placeholder){
            textView.text = ""
            textView.textColor = nameTXT.textColor
        }
        textView.becomeFirstResponder()
        
    }
    
    func checkClean(){
        
        if nameTXT.text != ""
        && locTXT.text != ""
        && (descTXT.text != "" && descTXT.text != placeholder) {
            
            nextBTN.enabled = true
            
        } else {
            
            nextBTN.enabled = false
            
        }
        
    }

    @IBAction func nextTPD(sender: UIBarButtonItem) {
        
        event.name = nameTXT.text
        event.location = locTXT.text
        event.description = descTXT.text
        
        var vc = storyboard?.instantiateViewControllerWithIdentifier("new_event_start_date_vc") as NewEventStartDateVC
        vc.event = event
        vc.existing = existing
        vc.events_delegate = events_delegate
        vc.loadView()
        
        if existing {
            
            vc.refresh_event_delegate = refresh_event_delegate
            vc.start_date.date = event.start_date as NSDate
            
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func cancelTPD(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}