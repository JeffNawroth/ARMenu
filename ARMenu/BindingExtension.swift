//
//  BindingExtension.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 10.02.22.
//

import Foundation
import SwiftUI

extension Binding{
    func toNonOptionalValue <T>(fallback: T )-> Binding<T> where Value == T?{
        Binding<T> {
            wrappedValue ?? fallback
        } set: {
            wrappedValue = $0
        }
    }
    

    func toNonOptionalString(fallback: String = "") -> Binding<String> where Value == String?{
        toNonOptionalValue(fallback: fallback)

    }
    
    func toNonOptionalCategory(fallback: Category = Category()) -> Binding<Category> where Value == Category?{
        toNonOptionalValue(fallback: fallback)

    }
    
    func toNonOptionalAllergens(fallback: [Allergen] = []) -> Binding<[Allergen]> where Value == [Allergen]?{
        toNonOptionalValue(fallback: fallback)
    }
    
    func toNonOptionalAdditives(fallback: [Additive] = []) -> Binding<[Additive]> where Value == [Additive]?{
        toNonOptionalValue(fallback: fallback)
    }
    
    func toNonOptionalToppings(fallback: [Topping] = []) -> Binding<[Topping]> where Value == [Topping]?{
        toNonOptionalValue(fallback: fallback)
    }
    
    func toNonOptionalNutritionFacts(fallback: NutritionFacts = NutritionFacts()) -> Binding<NutritionFacts> where Value == NutritionFacts?{
        toNonOptionalValue(fallback: fallback)
    }
    
    func toNonOptionalServingSize(fallback: ServingSize = ServingSize()) -> Binding<ServingSize> where Value == ServingSize?{
        toNonOptionalValue(fallback: fallback)
    }
    
    func toNonOptionalBoolean(fallback: Bool = false) -> Binding<Bool> where Value == Bool?{
        toNonOptionalValue(fallback: fallback)

    }
    
    func toNonOptionalDouble(fallback: Double = 0) -> Binding<Double> where Value == Double?{
        toNonOptionalValue(fallback: fallback)

    }
    
    func toNonOptionalProducts(fallback: [Product] = []) -> Binding<[Product]> where Value == [Product]?{
        toNonOptionalValue(fallback: fallback)

    }
    
}
