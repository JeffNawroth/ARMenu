//
//  OfferVisibilityButton.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 24.01.22.
//

import SwiftUI

struct OfferVisibilityButton: View {
    @EnvironmentObject var modelData: ModelData
    @State var isSet: Bool
    @State var offer: Offer
    @State var showsConfirmation: Bool = false
    var body: some View {
        Button {
            showsConfirmation.toggle()
        } label: {
            Image(systemName: isSet ? "eye.slash" : "eye")
        }
        .confirmationDialog(isSet ? "Dieses Angebot vor allen Kunden geheim halten?" : "Dieses Angebot für alle Kunden veröffentlichen?", isPresented: $showsConfirmation, titleVisibility: .visible) {
            
            Button(isSet ? "Geheim halten": "Veröffentlichen"){
                isSet.toggle()
                modelData.updateOffer(offerToUpdate: offer, isVisible: isSet)
            }
            Button("Abbrechen", role:.cancel) {}
            
        }
    }
}

struct OfferVisibilityButton_Previews: PreviewProvider {
    static var previews: some View {
        OfferVisibilityButton(isSet: true, offer: Offer.dummyOffer)
            .environmentObject(ModelData())
    }
}
