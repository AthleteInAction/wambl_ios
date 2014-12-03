class AppContacts {
    
    var contacts: [Contact] = []
    
    init(){
        
        update()
        
    }
    
    func update() {
        
        DB.contacts.load(self, completion: { (s, c) -> Void in
            
            if s {
                
                self.contacts = c
                self.contacts.sort({$0.sort_name < $1.sort_name})
                
            }
            
        })
        
    }
    
}