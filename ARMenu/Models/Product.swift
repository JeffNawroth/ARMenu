//
//  Product.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//
//Kommentar

import SwiftUI

struct Product: Identifiable{
    let id = UUID()
    var image: Image

    var name: String
    var category: String
    var price: Double
    var description: String
        
    var isVegan: Bool
    var isBio: Bool
    var isFairtrade: Bool
    
    var nutritionFacts: NutritionFacts
    var allergens: [Allergen]
    var additives: [Additive]
    
    
//    var servingSize
    
}
