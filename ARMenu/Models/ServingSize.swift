//
//  ServingSize.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 26.01.22.
//

import Foundation
import FirebaseFirestoreSwift

struct ServingSize: Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    var unit: Unit
    var size: Double
    
    static var dummyServingSize = ServingSize(unit: Unit.dummyUnits[1], size: 0.33)
}
