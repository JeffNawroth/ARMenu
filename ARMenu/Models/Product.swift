//
//  Product.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//
//Kommentar

import SwiftUI

struct Product: Identifiable{
    
    var id: String = UUID().uuidString
    var image: Image

    var name: String
    var category: Category
    var price: Double
    var description: String
        
    var isVegan: Bool
    var isBio: Bool
    var isFairtrade: Bool
    
    var nutritionFacts: NutritionFacts
    var allergens: [Allergen]
    var additives: [Additive]
    
    var isSelected: Bool

    
    
//    var servingSize
    
}
