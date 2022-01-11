//
//  ModelData.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import Foundation
import SwiftUI

var product1: Product = Product(image: Image("kaesekuchen"), name: "Käsekuchen", category: Category(name:"Kuchen"), price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true,isBio: true, isFairtrade: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false)
var product2: Product = Product(image: Image("spaghettieis"),name: "Spaghettieis", category: Category(name: "Eis"), price: 6.20, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", isVegan: true, isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false)
var product3:Product = Product(image: Image("eiscafe"), name: "Eiscafé", category: Category(name: "Getränke"), price: 4.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true, isBio: true, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false)

class ModelData: ObservableObject{
    
    @Published var products: [Product] =  [
        Product(image: Image("kaesekuchen"), name: "Käsekuchen", category: Category(name:"Kuchen"), price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true,isBio: true, isFairtrade: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false),
        
        Product(image: Image("spaghettieis"),name: "Spaghettieis", category: Category(name: "Eis"), price: 6.20, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", isVegan: true, isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false),
        
        Product(image: Image("eiscafe"), name: "Eiscafé", category: Category(name: "Getränke"), price: 4.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true, isBio: true, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false),
        
        Product(image: Image("waffel"), name: "Waffel", category: Category(name:"Waffeln"), price: 6.60, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true,isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false),

        Product(image: Image("eisbecher"), name: "Kleiner Eisbecher", category: Category(name: "Eis"), price: 2.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: false, isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false),

        Product(image: Image("eisbecher"), name: "Großer Eisbecher", category: Category(name: "Eis"), price: 3.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: false,isBio: false, isFairtrade: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false),

        Product(image: Image("apfelstreusel"), name: "Apfelstreusel", category: Category(name: "Kuchen"), price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", isVegan: false,isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false),

        Product(image: Image("eispappbecher"),name: "Eis To Go", category: Category(name: "Eis"), price: 2.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: false,isBio: true, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, isSelected: false)
    ]
    
    @Published var categories: [Category] = [Category(name: "Alles"),Category(name: "Kuchen"),Category(name: "Eis"),Category(name: "Getränke"),Category(name: "Waffeln")]
    
    @Published var offers: [Offer] = [
        Offer(image: Image("winterspecials"), title: "HÖRNKEN'S •WINTER• SPECIALS", description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", products: [product1,product2,product3]),
        Offer(image: Image("monatswaffel"), title: "MONATS WAFFEL!", description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", products: [product1,product2,product3]),
        Offer(image: Image("winterspecials"), title: "HÖRNKEN'S •WINTER• SPECIALS", description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", products: [product1,product2,product3]),
        Offer(image: Image("monatswaffel"), title: "MONATS WAFFEL!", description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", products: [product1,product2,product3])
    ]
}

