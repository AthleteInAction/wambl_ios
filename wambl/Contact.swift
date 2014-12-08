//  Contact.swift

import UIKit

class Contact {
    
    var user: PFUser = PFUser()
    var admin: Bool = false
    var creator: Bool = false
    var confirmed: Bool = false
    var first_name: String!
    var last_name: String!
    var db_name: String!
    var display_name: String!
    var contact_full: String!
    var sort_name: String!
    var phone_number: String!
    
    var empty: Bool = false
    
    init(){}
    
}