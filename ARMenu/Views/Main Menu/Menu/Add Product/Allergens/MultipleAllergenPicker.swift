//
//  MultipleAllergenPicker.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.01.22.
//

import SwiftUI

//Add a checkmark to selected allergens
struct MultipleAllergenPicker: View {
    var allergen: Allergen
    var isSelected: Bool
    var action: () -> Void
    var body: some View {
        
        
        Button(action: self.action) {
            HStack {
                Text(allergen.name)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }.foregroundColor(.primary)
    }
}

struct MultipleAllergenPicker_Previews: PreviewProvider {
    static var previews: some View {
        MultipleAllergenPicker(allergen: Allergen.dummyAllergens[0], isSelected: true) {
            
        }
    }
}
