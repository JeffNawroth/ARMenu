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
    
}
