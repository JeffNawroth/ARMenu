//
//  Product.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct Product: Identifiable{
    let id = UUID()
    var name: String
    var category: String
    var price: Double
    var description: String
    var image: Image
    var isVegan: Bool
    var nutritionFacts: NutritionFacts
    
    var isBio: Bool
    var isFairtrade: Bool
//    var servingSize
    
}
