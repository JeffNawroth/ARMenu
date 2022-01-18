//
//  SelectToppings.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 18.01.22.
//

import SwiftUI

struct SelectToppings: View {
    var toppings: [Topping] = Product.dummyToppings
    @Binding var selections: [Topping]
    var body: some View {
        List{
            ForEach(toppings, id: \.self){ topping in
                MultipleToppingPicker(topping: topping, isSelected: selections.contains{
                    $0.name == topping.name
                }){
                    if (selections.contains{$0.name == topping.name}){
                        selections.removeAll(where: {$0.name == topping.name})
                    }else{
                        selections.append(topping)
                    }
                }
            }
        }/*.searchable(text: $searchText)*/
            .navigationTitle("Toppings")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
    }
}

struct SelectToppings_Previews: PreviewProvider {
    static var previews: some View {
        SelectToppings(selections: .constant(Product.dummyToppings))
    }
}
