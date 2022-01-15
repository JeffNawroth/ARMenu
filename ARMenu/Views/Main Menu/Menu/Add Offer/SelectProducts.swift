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
    var body: some View {
        List{
            ForEach(modeldata.products){ product in
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
        }
    }
}

struct SelectProducts_Previews: PreviewProvider {
    static var previews: some View {
        SelectProducts(selections: .constant(ModelData().products))
            .environmentObject(ModelData())
    }
}
