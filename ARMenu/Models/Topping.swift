//
//  Topping.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 18.01.22.
//

import Foundation
import FirebaseFirestoreSwift


struct Topping:Identifiable, Hashable, Codable{
    @DocumentID var id: String?
    var name: String
    var price: Double
    
    static var dummyToppings: [Topping] = [Topping(name: "Sahne", price: 1.00), Topping(name: "heiße Kirschen", price: 1.50), Topping(name: "heiße Pflaumen", price: 1.50), Topping(name: "Schokosauce", price: 0.90), Topping(name: "Karamellsauce", price: 0.90), Topping(name: "Eis", price: 1.20), Topping(name: "Erdbeerhimbeersauce", price: 1.20),Topping(name: "Eishörnken extra", price: 0.30),Topping(name: "Krokant", price: 0.90),Topping(name: "Karamellisierte Nüsse", price: 1.50),Topping(name: "Knuspriger Streusel", price: 0.90), Topping(name: "Schokostreusel", price: 0.90)]
}
