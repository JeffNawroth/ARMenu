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
    var role: UserRole
    
    enum UserRole{
        case Admin
        case Customer
    }
    
    init(username: String, password: String, role: UserRole){
        self.username = username
        self.password = password
        self.role = role
    }
    
    init(role: UserRole){
        self.role = role
    }
}
