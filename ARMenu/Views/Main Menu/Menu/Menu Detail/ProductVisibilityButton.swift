//
//  VisibilityButton.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 22.01.22.
//

import SwiftUI

struct ProductVisibilityButton: View {
    @EnvironmentObject var modelData: ModelData
    @State var isSet: Bool
    @State var product: Product
    @State var showsConfirmation: Bool = false
    var body: some View {
        Button {
            showsConfirmation.toggle()
        } label: {
            Image(systemName: isSet ? "eye.slash" : "eye")
        }
        .confirmationDialog(isSet ? "Dieses Produkt vor allen Kunden geheim halten?" : "Dieses Produkt für alle Kunden veröffentlichen?", isPresented: $showsConfirmation, titleVisibility: .visible) {
            
            Button(isSet ? "Geheim halten": "Veröffentlichen"){
                isSet.toggle()
                modelData.updateProduct(productToUpdate: product, isVisible: isSet)
            }
            Button("Abbrechen", role:.cancel) {}
            
        }
    }
}

struct VisibilityButton_Previews: PreviewProvider {
    static var previews: some View {
        ProductVisibilityButton(isSet: true, product: Product.dummyProducts[0])

    }
}
