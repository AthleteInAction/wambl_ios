//  Contact.swift

import UIKit

class Contact {
    
    var user: PFUser!
    var admin: Bool = false
    var creator: Bool = false
    var first_name: String!
    var last_name: String!
    var db_name: String!
    var display_name: String!
    var contact_full: String!
    var phone_number: String!
    
    var empty: Bool = false
    
    init(){}
    
}