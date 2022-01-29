//
//  Allergen.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.01.22.
//

import Foundation
import FirebaseFirestoreSwift

struct Allergen:Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    var name: String
    
    
    static var dummyAllergens: [Allergen] = [Allergen(name: "Gluten"), Allergen(name: "Krebstiere"), Allergen(name: "Fisch"),Allergen(name: "Ei")]
}
