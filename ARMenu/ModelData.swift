//
//  ModelData.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import Foundation
import SwiftUI

struct ModelData{
    var products: [Product] =  [
        Product(name: "Käsekuchen", category: "Kuchen", price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", image: Image("kaesekuchen"), isVegan: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), isBio: true, isFairtrade: true),
        
        Product(name: "Spaghettieis", category: "Eis", price: 6.20, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", image: Image("spaghettieis"), isVegan: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), isBio: false, isFairtrade: false),
        
        Product(name: "Eiscafé", category: "Getränk", price: 4.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", image: Image("eiscafe"), isVegan: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), isBio: true, isFairtrade: false),
        
        Product(name: "Waffel", category: "Waffel", price: 6.60, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", image: Image("waffel"), isVegan: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), isBio: false, isFairtrade: false),
        
        Product(name: "Kleiner Eisbecher", category: "Eis", price: 2.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", image: Image("eisbecher"), isVegan: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), isBio: false, isFairtrade: false),
        
        Product(name: "Großer Eisbecher", category: "Eis", price: 3.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", image: Image("eisbecher"), isVegan: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), isBio: false, isFairtrade: true),
        
        Product(name: "Apfelstreusel", category: "Kuchen", price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", image: Image("apfelstreusel"), isVegan: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), isBio: false, isFairtrade: false),
        
        Product(name: "Eis To Go", category: "Eis", price: 2.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", image: Image("eispappbecher"), isVegan: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), isBio: true, isFairtrade: false)

    ]
    
    var users: [User] = [User(username: "imHoernken", password: "imHoernken", role: .Admin), User(role: .Customer)]
    
    var categories:[String] = ["Alles", "Kuchen", "Eis", "Getränk","Waffel"]
    
//    var allergens: [Allergen] = [Allergen(name: "Gluten"), Allergen(name:"Krebstiere"), Allergen(name: "Fisch"), Allergen(name: "Ei")]
//    var additives: [Additive] = [Additive(name: "Farbstoffe"), Additive(name: "Emulgatoren"), Additive(name: "Konservierungsmittel"), Additive(name: "Süßungsmittel")]
    
    
}

