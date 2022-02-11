//
//  Additive.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.01.22.
//

import Foundation
import FirebaseFirestoreSwift

struct Additive: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    var name: String
    
    
    static var dummyAdditives: [Additive] = [Additive(name:"Farbstoffe"),Additive(name:"Emulgatoren"),Additive(name:"Konservierungsmittel"),Additive(name:"Süßungsmittel")]

}
