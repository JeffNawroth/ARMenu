//
//  SelectProducts.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 15.01.22.
//

import SwiftUI

struct SelectProducts: View {
    @EnvironmentObject var modeldata: ModelData
    @Binding var selections: [Product]
    @State private var searchText = ""
    
    var searchResults: [Product] {
        if searchText.isEmpty {
            return modeldata.products
        } else {
            return modeldata.products.filter { $0.name.contains(searchText) }
        }
    }
    
    var body: some View {
        List{
            ForEach(searchResults){ product in
                MultipleProductPicker(product: product, isSelected: selections.contains{
                    $0.id == product.id
                }){
                    if (selections.contains{$0.id == product.id}){
                        selections.removeAll(where: {$0.id == product.id})
                    }else{
                        selections.append(product)
                    }
                }
            }
        }.searchable(text: $searchText)
            .navigationTitle("Produkte")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
        
        
    }
}

struct SelectProducts_Previews: PreviewProvider {
    static var previews: some View {
        SelectProducts(selections: .constant(ModelData().products))
            .environmentObject(ModelData())
    }
}
