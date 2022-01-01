//
//  Allergen.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 29.12.21.
//

import Foundation

struct Allergen: Identifiable, Hashable{
    let id = UUID()
    var name: String
    var isSelected: Bool = false
    
  static var dummyAllergens: [Allergen] = [Allergen(name: "Gluten"), Allergen(name:"Krebstiere"), Allergen(name: "Fisch"), Allergen(name: "Ei")]
}
