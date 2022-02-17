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
        ZStack{
            if let image = offer.image{
                AnimatedImage(url: URL(string: image))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(width: 125)
            }else{
                ZStack{
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(width: 125)
                        .foregroundColor(.gray)
                }
                
            }
        }
        .padding(.top, 10)

    }
    
}

struct Offer_Previews: PreviewProvider {
    static var previews: some View {
        OfferColumn(offer: Offer.dummyOffer)
    }
}
