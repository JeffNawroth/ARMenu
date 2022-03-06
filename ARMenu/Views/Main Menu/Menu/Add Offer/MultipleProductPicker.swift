//
//  MultipleProductPicker.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 15.01.22.
//

import SwiftUI

struct MultipleProductPicker: View {
    var product: Product
    var isSelected: Bool
    var action: () -> Void
    
    //Add a checkmark to selected products
    var body: some View {
        Button(action: self.action) {
            HStack {
               MenuRow(product: product)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }.foregroundColor(.primary)
    }
}

struct MultipleProductPicker_Previews: PreviewProvider {
    static var previews: some View {
        MultipleProductPicker(product: Product.dummyProduct, isSelected: true){
            
        }
    }
}
