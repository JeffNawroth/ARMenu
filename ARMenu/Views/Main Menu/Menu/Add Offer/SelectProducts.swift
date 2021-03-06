//
//  SelectProducts.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 15.01.22.
//

import SwiftUI

struct SelectProducts: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var selections: [String]
    @State private var searchText = ""
    
    //Filter search results
    var searchResults: [Product] {
        if searchText.isEmpty {
            return modelData.products
        } else {
            return modelData.products.filter { $0.name!.contains(searchText) }
        }
    }
    
    var body: some View {
        //Show selectable products
        List{
            ForEach(searchResults){ product in
                MultipleProductPicker(product: product, isSelected: selections.contains{
                    $0 == product.id
                }){
                    if (selections.contains{$0 == product.id}){
                        selections.removeAll(where: {$0 == product.id})
                    }else{
                        selections.append(product.id!)
                    }
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Produkte")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
        
        
    }
}

struct SelectProducts_Previews: PreviewProvider {
    static var previews: some View {
        SelectProducts(selections: .constant([""]))
            .environmentObject(ModelData(menuId: ""))
    }
}
