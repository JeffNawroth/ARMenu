//
//  User.swift
//  ARMenu
//
//  Created by Eren Cicek on 17.02.22.
//

import Foundation

struct User{
    var uid: String?
    var email: String?
    var userRole: role?
    
    enum role{
        case admin
        case customer
    }
    
    
//    init(uid: String, email: String){
//        self.uid = uid
//        self.email = email
//    }
    
    
}
//extension User{
//    init?(data: [String: Any]){
//        let uid = data["userID"] as? String ?? ""
//        let email = data["email"] as? String ?? ""
//
//        self.init(uid: uid, email: email)
//    }
//}

