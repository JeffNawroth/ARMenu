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
    var body: some View {
        Button {
            isSet.toggle()
            modelData.updateOffer(offerToUpdate: offer, isVisible: isSet)
        } label: {
            Image(systemName: isSet ? "eye.slash" : "eye")
        }
    }
}

struct OfferVisibilityButton_Previews: PreviewProvider {
    static var previews: some View {
        OfferVisibilityButton(isSet: true, offer: Offer.dummyOffer)
            .environmentObject(ModelData())
    }
}
