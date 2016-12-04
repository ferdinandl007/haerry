//
//  DBProvider.swift
//  haerry
//
//  Created by Ferdinand Lösch on 03/12/2016.
//  Copyright © 2016 Ferdinand Lösch. All rights reserved.
//

import Foundation
import FirebaseDatabase
import PubNub

class DBProvider {
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider {
        return _instance;
    }

    
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference();
    }
    
    var UserRef: FIRDatabaseReference {
        return dbRef.child(Constons.USER)
    }

    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constons.EMAIL: email, Constons.PASSWORD: password]
        
        UserRef.child(withID).child(Constons.DATA).setValue(data);
    }
    
    
    
    
    

    
    
    
    
}
