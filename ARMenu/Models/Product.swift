//
//  Product.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//
//Kommentar

import SwiftUI
import FirebaseFirestoreSwift


struct Product: Identifiable, Codable{

    @DocumentID var id: String?
    var image: String

    var name: String
//    var category: String
    var price: Double
    var description: String
        
    var isVegan: Bool
    var isBio: Bool
    var isFairtrade: Bool
    
    var nutritionFacts: NutritionFacts
//    var allergens: [String]
//    var additives: [String]
    
    
//    var servingSize
    
}
