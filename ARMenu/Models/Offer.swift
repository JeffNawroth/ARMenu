//
//  Offer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 04.01.22.
//

import Foundation
import SwiftUI

struct Offer: Identifiable{
    var id: String = UUID().uuidString
    var image: Image
    var title: String
    var description: String
    var products: [Product]

}
