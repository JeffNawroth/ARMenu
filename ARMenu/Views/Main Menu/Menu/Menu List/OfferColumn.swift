//
//  Offer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 04.01.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct OfferColumn: View {
    var offer: Offer
    var body: some View {
        
        AnimatedImage(url: URL(string: offer.image))
            .resizable()
            .scaledToFit()
            .cornerRadius(20)
            .frame(width: 125)
        
    }
    
}

struct Offer_Previews: PreviewProvider {
    static var previews: some View {
        OfferColumn(offer: Offer.dummyOffer)
    }
}
