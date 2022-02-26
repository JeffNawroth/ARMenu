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
    var servingSizeId: UUID = UUID()
    var unit: Unit?
    var size: Double?
    var price: Double?
    

    
    static var dummyServingSizes = [ServingSize(unit: Unit.dummyUnits[1], size: 0.33, price: 1.30),ServingSize(unit: Unit.dummyUnits[1], size: 0.5, price: 2),ServingSize(unit: Unit.dummyUnits[1], size: 0.75, price: 3)]
}
