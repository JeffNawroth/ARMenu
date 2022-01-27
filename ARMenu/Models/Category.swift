//
//  Category.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.01.22.
//

import Foundation
import FirebaseFirestoreSwift

struct Category:Identifiable, Codable, Hashable{
    @DocumentID var id: String?
    var name: String

}
