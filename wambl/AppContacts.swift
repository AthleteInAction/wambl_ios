class AppContacts {
    
    var contacts: [Contact] = []
    
    init(){
        
        
        
    }
    
    func update(completion: (s: Bool) -> Void) {
        
        DB.contacts.load { (s, c) -> Void in
            
            if s {
                
                self.contacts = c
                self.contacts.sort({$0.sort_name < $1.sort_name})
                
            } else {
                
                
                
            }
            
            completion(s: s)
            
        }
        
    }
    
}