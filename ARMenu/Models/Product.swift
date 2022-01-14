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
    var category: String
    var price: Double
    var description: String
        
    var isVegan: Bool
    var isBio: Bool
    var isFairtrade: Bool
    
    var nutritionFacts: NutritionFacts
    var allergens: [String]
    var additives: [String]
    
    var isSelected: Bool

    static var dummyAdditives: [String] = ["Farbstoffe","Emulgatoren", "Konservierungsmittel","Süßungsmittel"]
    static var dummyAllergens: [String] = ["Gluten", "Krebstiere", "Fisch", "Ei"]
    static var categories: [String] = ["Alles","Kuchen","Eis","Getränke","Waffeln"]

//    var servingSize
    
}
