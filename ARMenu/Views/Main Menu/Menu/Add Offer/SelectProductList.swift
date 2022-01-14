//
//  SelectProducts.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 10.01.22.
//

import SwiftUI

struct SelectProductList: View {
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
                    SelectProductRow(product: product)
                }
                
            }
            
        }
        .padding(.top)
        .navigationBarTitle("Produkte", displayMode: .inline)
        .listStyle(.plain)
    }
}

struct SelectProducts_Previews: PreviewProvider {
    static var previews: some View {
        SelectProductList(productsDummy: .constant(ModelData().products))
            .environmentObject(ModelData())
    }
}
