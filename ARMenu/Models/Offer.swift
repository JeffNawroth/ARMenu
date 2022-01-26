//
//  Offer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 04.01.22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Offer: Identifiable, Codable{
   @DocumentID var id: String?
    var image: String
    var title: String
    var description: String
    var products: [Product]
    var isVisible: Bool
    
    static var dummyOffer = Offer(image:"https://firebasestorage.googleapis.com/v0/b/armenu-12bfd.appspot.com/o/Monatswaffel.jpg?alt=media&token=cf9d615b-b922-4160-a500-e15080e92848" , title: "Im Hörnken Angebot", description: "Dummy beschreibung", products: [Product(image: "https://firebasestorage.googleapis.com/v0/b/armenu-12bfd.appspot.com/o/kaesekuchen.jpg?alt=media&token=bdb779a8-c191-441b-a14f-9af92cf4568d", name: "Käsekuchen", category: Category(name: "Kuchen"), price: 3.50, description: "Suscipit inceptos est felis purus aenean aliquet adipiscing diam venenatis, augue nibh duis neque aliquam tellus condimentum sagittis vivamus.",  servingSize: ServingSize.dummyServingSize, isVegan: true,isBio: true, isFairtrade: true, isVisible: true, nutritionFacts: NutritionFacts(calories: 573, fat: 23.2, carbs: 44.9, protein: 3.4),allergens: Allergen.dummyAllergens, additives: Additive.dummyAdditives, toppings: Topping.dummyToppings)], isVisible: true)

}
