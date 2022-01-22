//
//  VisibilityButton.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 22.01.22.
//

import SwiftUI

struct VisibilityButton: View {
    @EnvironmentObject var modelData: ModelData
    @State var isSet: Bool
    @State var product: Product
    var body: some View {
        Button {
            isSet.toggle()
            modelData.updateData(productToUpdate: product, isVisible: isSet)
        } label: {
            Image(systemName: isSet ? "eye.slash" : "eye")
        }
    }
}

struct VisibilityButton_Previews: PreviewProvider {
    static var previews: some View {
        VisibilityButton(isSet: true, product: Product.dummyProducts[0])
            .environmentObject(ModelData())

    }
}
