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
    @Binding var mode: EditMode
    var action: () -> Void
    var body: some View {
        ZStack{
            AnimatedImage(url: URL(string: offer.image))
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .frame(width: 125)
            
            
            if(mode == .active){
                Button(action: action){
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(Color.red)
                        .padding(.top)
                        .font(.system(size: 22))
                        .offset(x: 60, y: -60)
                }
                .buttonStyle(.plain)
            }
        }
        
        
        
        
    }
    
}

struct Offer_Previews: PreviewProvider {
    static var previews: some View {
        OfferColumn(offer: Offer.dummyOffer, mode: .constant(.active)){
            
        }
    }
}