//
//  Product.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import FirebaseFirestoreSwift

struct Product: Identifiable, Codable, Hashable{
    
    @DocumentID var id: String?
    var image: String?
    var model: String?
    var name: String?
    var category: Category?
    var price: Double?
    var description: String?
    var servingSizes: [ServingSize]?
        
    var isVegan: Bool?
    var isBio: Bool?
    var isFairtrade: Bool?
    var isVisible: Bool?
    
    
    var nutritionFacts: NutritionFacts?
    var allergens: [Allergen]?
    var additives: [Additive]?
    var toppings: [Topping]?
    
    static var dummyProduct = Product(image:"https://firebasestorage.googleapis.com/v0/b/armenu-12bfd.appspot.com/o/kaesekuchen.jpg?alt=media&token=bdb779a8-c191-441b-a14f-9af92cf4568d", model: "https://firebasestorage.googleapis.com/v0/b/armenu-12bfd.appspot.com/o/3DModels%2Feisbecher.usdz?alt=media&token=f7f8f0d9-2af8-413f-9237-199ae3000f96", name: "Käsekuchen", category: Category(name: "Kuchen"), price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  servingSizes: ServingSize.dummyServingSizes, isVegan: true,isBio: true, isFairtrade: true, isVisible: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, toppings: Topping.dummyToppings)
    
}


