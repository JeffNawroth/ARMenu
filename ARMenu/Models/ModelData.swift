//
//  ModelData.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import Foundation
import SwiftUI

var product1: Product = Product(image: Image("kaesekuchen"), name: "Käsekuchen", category: "Kuchen", price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true,isBio: true, isFairtrade: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives)
var product2: Product = Product(image: Image("spaghettieis"),name: "Spaghettieis", category: "Eis", price: 6.20, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", isVegan: true, isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4), allergens: Product.dummyAllergens, additives: Product.dummyAdditives)
var product3:Product = Product(image: Image("eiscafe"), name: "Eiscafé", category: "Getränke", price: 4.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true, isBio: true, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives)

class ModelData: ObservableObject{
    
    @Published var products: [Product] =  [
        Product(image: Image("kaesekuchen"), name: "Käsekuchen", category: "Kuchen", price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true,isBio: true, isFairtrade: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives, toppings: Product.dummyToppings),
        
        Product(image: Image("spaghettieis"),name: "Spaghettieis", category: "Eis", price: 6.20, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", isVegan: true, isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives),
        
        Product(image: Image("eiscafe"), name: "Eiscafé", category: "Getränke", price: 4.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true, isBio: true, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives),
        
        Product(image: Image("waffel"), name: "Waffel", category: "Waffeln", price: 6.60, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: true,isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives),

        Product(image: Image("eisbecher"), name: "Kleiner Eisbecher", category: "Eis", price: 2.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: false, isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives),

        Product(image: Image("eisbecher"), name: "Großer Eisbecher", category: "Eis", price: 3.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: false,isBio: false, isFairtrade: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives),

        Product(image: Image("apfelstreusel"), name: "Apfelstreusel", category: "Kuchen", price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", isVegan: false,isBio: false, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives),

        Product(image: Image("eispappbecher"),name: "Eis To Go", category: "Eis", price: 2.40, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  isVegan: false,isBio: true, isFairtrade: false, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Product.dummyAllergens, additives: Product.dummyAdditives)
    ]
    
   
    @Published var offers: [Offer] = [
        Offer(image: Image("winterspecials"), title: "HÖRNKEN'S •WINTER• SPECIALS", description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", products: [product1,product2,product3]),
        Offer(image: Image("monatswaffel"), title: "MONATS WAFFEL!", description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", products: [product1,product2,product3]),
        Offer(image: Image("winterspecials"), title: "HÖRNKEN'S •WINTER• SPECIALS", description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", products: [product1,product2,product3]),
        Offer(image: Image("monatswaffel"), title: "MONATS WAFFEL!", description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.", products: [product1,product2,product3])
    ]
}

