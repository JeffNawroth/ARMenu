//
//  SelectProductsRow.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 11.01.22.
//

import SwiftUI

struct SelectProductsRow: View {
    var product: Product
    var body: some View {
        HStack{
            MenuRow(product: product)
            if product.isSelected{
                Image(systemName: "checkmark")
            }
        }
    }
}

struct SelectProductsRow_Previews: PreviewProvider {
    static var previews: some View {
        SelectProductsRow(product: ModelData().products[0])
    }
}
