//
//  User.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import Foundation

struct User:Identifiable{
    var id = UUID()
    var username: String?
    var password: String?
   /* var role: UserRole
    
    enum UserRole{
        case Admin
        case Customer
    }*/
    
    
   static var dummyUser = User(username: "imHoernken", password: "imHoernken")

    
}

