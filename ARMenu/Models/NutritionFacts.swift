//
//  NutritionFacts.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import Foundation

struct NutritionFacts: Codable, Hashable{
    var calories: Int?
    var fat: Double?
    var carbs: Double?
    var protein: Double?
    
    init(){}
    
    init(calories: Int, fat: Double, carbs: Double, protein:Double){
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
    }
    
}


