//
//  Event.swift
//  wambl
//
//  Created by grobinson on 12/1/14.
//  Copyright (c) 2014 Will Robinson. All rights reserved.
//

import Foundation

class Event {
    
    var object: PFObject!
    var admin: Bool = false
    var creator: Bool = false
    var confirmed: Bool = false
    var is_loaded: Bool = false
    
    init(){}
    
}