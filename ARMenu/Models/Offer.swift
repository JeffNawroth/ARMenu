//
//  Offer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 04.01.22.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct Offer: Identifiable, Codable, Hashable{
   @DocumentID var id: String?
    var image: String?
    var title: String?
    var description: String?
    var products: [Product]?
    var isVisible: Bool?
    
    static var dummyOffer = Offer(image:"https://firebasestorage.googleapis.com/v0/b/armenu-12bfd.appspot.com/o/Monatswaffel.jpg?alt=media&token=cf9d615b-b922-4160-a500-e15080e92848" , title: "Im Hörnken Angebot", description: "Dummy beschreibung", products: [Product.dummyProduct] , isVisible: true)

}
