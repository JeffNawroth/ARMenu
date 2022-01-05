//
//  OfferDetail.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 04.01.22.
//

import SwiftUI

struct OfferDetail: View {
    var offer: Offer
    var body: some View {
        
        ScrollView{
            offer.image
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
            }
            .padding()
            Divider()

     Spacer()
            
            VStack(alignment: .leading){
                Text("Produkte")
                    .font(.headline)
                
                ForEach(offer.products){ product in
                        NavigationLink {
                            MenuDetail(product: product)
                        } label: {
                            VStack{
                                MenuRow(product: product)
                                Divider()
                            }
                            Image(systemName: "chevron.right")
                        }
                    }
            }.padding(.horizontal)
           
           
                
                .navigationBarTitle(Text(offer.title), displayMode: .inline)
        }
        
        
    }
}

struct OfferDetail_Previews: PreviewProvider {
    static var previews: some View {
        OfferDetail(offer: ModelData().offers[0])
    }
}
