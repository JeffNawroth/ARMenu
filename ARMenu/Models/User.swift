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
    
}
    

