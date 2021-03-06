//
//  OfferDetail.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 04.01.22.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct OfferDetail: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingSheet = false
    @State private var showingDeleteConfirmation = false
    var offer: Offer
    var loggedInUser = Auth.auth().currentUser
    
    
    //Filter products that are assigned to an offer based on the Id
    var products: [Product]{
        modelData.products.filter{
            offer.products != nil && offer.products!.contains($0.id!)
        }
    }
    
    var body: some View {
        
        
        ScrollView{
            //Show image
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
                
                //Show title
                Text(offer.title!)
                    .font(.title)
                
                Divider()
                
                
                
                //Show description
                if let description = offer.description{
                    
                    Text("Beschreibung")
                        .font(.title2)
                    
                    Text(description)
                    
                }
                
                
                
                //Show Products
                if !products.isEmpty{
                    if offer.description != nil{
                        Divider()
                        
                    }
                    
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
            
            Spacer()
        }
        .navigationTitle(Text(offer.title!))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            //Buttons to delete or edit an offer
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet = true
                } label: {
                    if !loggedInUser!.isAnonymous{
                        Image(systemName: "square.and.pencil")
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    AddOffer(showingSheet: $showingSheet, offerDummy: offer, mode: .edit)
                }
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingDeleteConfirmation = true
                } label: {
                    if !loggedInUser!.isAnonymous{
                        Image(systemName: "trash")
                    }
                }
                .confirmationDialog("Dieses Angebot wirklich l??schen?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                    Button("L??schen", role: .destructive){
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
