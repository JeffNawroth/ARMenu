//
//  OfferDetail.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 04.01.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct OfferDetail: View {
    var offer: Offer

    var body: some View {
        
        ScrollView{
            AnimatedImage(url: URL(string: offer.image))
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding()
            
            VStack(alignment: .leading){
                
                    Text(offer.title)
                        .font(.title)
                        .padding(.bottom)
                    
                    Text(offer.description)
                        .foregroundColor(.secondary)
                        .padding(.bottom)

                
             
            
                Text("Produkte")
                    .font(.headline)
                
                ForEach(offer.products){ product in
                    NavigationLink {
                        MenuDetail(product: product)
                    } label: {
                        VStack{
                            MenuRow(product: product)
                                .foregroundColor(Color.primary)
                            
                            Divider()
                        }
                        Image(systemName: "chevron.right")
                            .imageScale(.small)
                            .foregroundColor(Color.gray)
                    }
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle(Text(offer.title))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                OfferVisibilityButton(isSet: offer.isVisible, offer: offer)
            }
        }
    }
}

struct OfferDetail_Previews: PreviewProvider {
    static var previews: some View {
        OfferDetail(offer: Offer.dummyOffer)
    }
}
