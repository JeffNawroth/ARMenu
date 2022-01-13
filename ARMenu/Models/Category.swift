//
//  Category.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 01.01.22.
//

import Foundation


struct Category: Identifiable, Hashable, Codable{
    var id:String = UUID().uuidString
    var name: String
        
}
