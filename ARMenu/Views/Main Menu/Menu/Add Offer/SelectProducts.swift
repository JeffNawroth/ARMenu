//
//  SelectProducts.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 10.01.22.
//

import SwiftUI

struct SelectProducts: View {
    @EnvironmentObject var modelData: ModelData
    
    @Binding var productsDummy: [Product]
    
    var body: some View {
        
        List{
            ForEach(productsDummy){ product in
                Button {
                    if let index = productsDummy.firstIndex(where: {$0.id == product.id}){
                        productsDummy[index].isSelected.toggle()
                        
                    }
                } label: {
                    SelectProductsRow(product: product)
                }
                
            }
        }
        .navigationBarTitle("Produkte", displayMode: .inline)
        .listStyle(.plain)
    }
}

struct SelectProducts_Previews: PreviewProvider {
    static var previews: some View {
        SelectProducts(productsDummy: .constant(ModelData().products))
            .environmentObject(ModelData())
    }
}
