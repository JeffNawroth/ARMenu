//
//  OfferDetail.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 04.01.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct OfferDetail: View {
    @EnvironmentObject var modelData: ModelData
    var offer: Offer
    @State private var showingSheet = false
    @State private var showingDeleteConfirmation = false
    
    
    
    var products: [Product]{
            modelData.products.filter{
                offer.products != nil && offer.products!.contains($0.id!)
            }
        }

    var body: some View {
        
        
        ScrollView{
            if let image = offer.image{
                AnimatedImage(url: URL(string: image))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding()
            }
            else{
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding()
                    .foregroundColor(.gray)
            }
            
            
            VStack(alignment: .leading){
                
                    Text(offer.title!)
                        .font(.title)
                        .padding(.bottom)
                    
                Text(offer.description ?? "")
                        .foregroundColor(.secondary)
                        .padding(.bottom)

                
             
                if let products = products{
                    Text("Produkte")
                        .font(.headline)
                    
                    ForEach(products, id: \.self){ product in
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

              
            }
            .padding(.horizontal)
        }
        .navigationTitle(Text(offer.title!))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .sheet(isPresented: $showingSheet) {
                    AddOffer(showingSheet: $showingSheet, offerDummy: offer, mode: .edit)
                }
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                }
                .confirmationDialog("Dieses Angebot wirklich löschen?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                    Button("Löschen", role: .destructive){
                        modelData.deleteOffer(offerToDelete: offer)
                    }
                }

            }
        }
    }
}

struct OfferDetail_Previews: PreviewProvider {
    static var previews: some View {
        OfferDetail(offer: Offer.dummyOffer)
    }
}
