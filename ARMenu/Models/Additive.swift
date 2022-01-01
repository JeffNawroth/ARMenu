//
//  Additive.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 29.12.21.
//

import Foundation

struct Additive: Identifiable, Hashable{
    let id = UUID()
    var name: String
    
    
    static var dummyAdditives: [Additive] = [Additive(name: "Farbstoffe"), Additive(name: "Emulgatoren"), Additive(name: "Konservierungsmittel"), Additive(name: "Süßungsmittel")]

    
}
