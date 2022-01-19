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
    @State private var searchText = ""
    @State private var showingSheet = false
    
    var searchResults: [Topping] {
        if searchText.isEmpty {
            return toppings
        } else {
            return toppings.filter { $0.name.contains(searchText) }
        }
    }

    var body: some View {
        List{
            ForEach(searchResults, id: \.self){ topping in
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
           
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet = true

                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showingSheet) {
                    //AddProduct(showingSheet: $showingSheet)
                    AddTopping(showingSheet: $showingSheet)
                }

            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
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
