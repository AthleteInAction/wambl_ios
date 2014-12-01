//
//  EventDetailVC.swift
//  wambl
//
//  Created by grobinson on 12/1/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import UIKit

class EventDetailVC: UITableViewController {
    
    var event: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var i: PFRelation = event.object["users"] as PFRelation
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }
    
}
