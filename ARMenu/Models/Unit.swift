//
//  ServingUnit.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 26.01.22.
//

import Foundation
import FirebaseFirestoreSwift

struct Unit: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    var name: String
    
    
    static var dummyUnits: [Unit] = [Unit(name:"g"),Unit(name: "l"), Unit(name: "Stück")]
}
