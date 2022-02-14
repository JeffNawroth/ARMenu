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
            if let image = offer.image{
                AnimatedImage(url: URL(string: image))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(width: 125)
            }else{
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(width: 125)
                    .foregroundColor(.gray)
            }
            
            if(mode == .active){
                Button(action: action){
                    Image(systemName: "minus.circle.fill")
                        .renderingMode(.original)
                        .font(.system(size: 24))
                        .offset(x: 60, y: -60)
                    
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.top, 10)
        
        
        
        
    }
    
}

struct Offer_Previews: PreviewProvider {
    static var previews: some View {
        OfferColumn(offer: Offer.dummyOffer, mode: .constant(.active)){
            
        }
    }
}
