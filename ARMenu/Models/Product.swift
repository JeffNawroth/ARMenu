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
    
    var toppings: [Topping]
    
    
    static var dummyAdditives: [String] = ["Farbstoffe","Emulgatoren", "Konservierungsmittel","Süßungsmittel"]
    static var dummyAllergens: [String] = ["Gluten", "Krebstiere", "Fisch", "Ei"]
    static var categories: [String] = ["Alles","Kuchen","Eis","Getränke","Waffeln"]
    
    static var dummyToppings: [Topping] = [Topping(name: "Sahne", price: 1.00), Topping(name: "heiße Kirschen", price: 1.50), Topping(name: "heiße Pflaumen", price: 1.50), Topping(name: "Schokosauce", price: 0.90), Topping(name: "Karamellsauce", price: 0.90), Topping(name: "Eis", price: 1.20), Topping(name: "Erdbeerhimbeersauce", price: 1.20),Topping(name: "Eishörnken extra", price: 0.30),Topping(name: "Krokant", price: 0.90),Topping(name: "Karamellisierte Nüsse", price: 1.50),Topping(name: "Knuspriger Streusel", price: 0.90), Topping(name: "Schokostreusel", price: 0.90)]
//    var servingSize
    
}


