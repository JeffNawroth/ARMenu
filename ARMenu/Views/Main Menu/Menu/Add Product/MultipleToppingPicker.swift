//
//  MultipleToppingPicker.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 18.01.22.
//

import SwiftUI

struct MultipleToppingPicker: View {
    var topping: Topping
    var isSelected: Bool
    var action: () -> Void
    var body: some View {
        
        
        Button(action: self.action) {
            HStack {
                Text(topping.name)
                Spacer()
                Text("+ \(topping.price, specifier: "%.2f")")
                if self.isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }.foregroundColor(.primary)
    }
}

struct MultipleToppingPicker_Previews: PreviewProvider {
    static var previews: some View {
        MultipleToppingPicker(topping: Product.dummyToppings[0], isSelected: true) {
            
        }
    }
}
