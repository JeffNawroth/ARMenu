//
//  MenuList.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import FirebaseAuth

struct MenuList: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var modelData: ModelData
    @State private var showingProductSheet = false
    @State private var showingOfferSheet = false
    @State private var searchText = ""
    @State private var showsConfirmation = false
    @State private var showsOfferConfirmation = false
    @State private var selectedCategory = Category(name: "Alles")
    var loggedInUser = Auth.auth().currentUser

    //Filter the Products for the logged in user
    var filteredProducts: [Product]{
            if !loggedInUser!.isAnonymous{
                        return modelData.products
                    }else{
                        return modelData.products.filter{
                            $0.isVisible!
                        }
                    }
        }
    
    //Filter the Offers for the logged in user
    var filteredOffers: [Offer]{
            if !loggedInUser!.isAnonymous{
                        return modelData.offers
                    }else{
                        return modelData.offers.filter{
                            $0.isVisible!
                        }
                    }
        }
    
    //Filter categories
    var filteredMenuList: [Product] {
        filteredProducts.filter{ product in
            (selectedCategory.name == "Alles" || selectedCategory.name == product.category?.name)
        }
    }
    
    //Filter search results
    var searchResults: [Product] {
        if searchText.isEmpty {
            return filteredMenuList
        } else {
            return filteredMenuList.filter { $0.name!.contains(searchText) || $0.category != nil && $0.category!.name.contains(searchText)}
        }
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                if !modelData.categories.isEmpty{
                    Section{
                        Picker("Kategorie", selection: $selectedCategory) {
                            Text("Alles").tag(Category(name: "Alles"))
                            ForEach(modelData.categories, id: \.self) {
                                Text($0.name)
                            }
                        }
                    }
                }
                
                if !modelData.offers.isEmpty{
                    Section(header: Text("Angebote")){
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack{
                                ForEach(filteredOffers){ offer in
                                    NavigationLink{
                                        OfferDetail(offer: offer)
                                            .opacity(offer.isVisible ?? false ? 1: 0.25)
                                        
                                    } label:{
                                        
                                        OfferColumn(offer: offer)
                                            .opacity(offer.isVisible ?? false ? 1: 0.25)
                                        
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets())
                    }.listRowBackground(Color.clear)
                }
                
                
                if !modelData.products.isEmpty{
                    Section(header: Text("Produkte")){
                        List{
                            ForEach(searchResults){ product in
                                NavigationLink{
                                    MenuDetail(product: product)
                                        .opacity(product.isVisible ?? false ? 1: 0.25)
                                } label:{
                                    MenuRow(product: product)
                                        .opacity(product.isVisible ?? false ? 1: 0.25)
                                }
                            }
                        }
                    }
                }
               
            }
            .navigationTitle("Speisekarte")
            .searchable(text: $searchText)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        if !loggedInUser!.isAnonymous{
                            showsConfirmation = true
                        }
                        else{
                            session.signOut()
                        }
                    } label: {
                        if !loggedInUser!.isAnonymous{
                            Image(systemName: "plus")
                        }else{
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                        }
                    }
                    .confirmationDialog("", isPresented: $showsConfirmation) {
                        Button("Angebot erstellen"){
                            showingOfferSheet = true
                        }
                        Button("Produkt erstellen"){
                            showingProductSheet = true
                        }
                        
                    }
                    
                    .sheet(isPresented: $showingProductSheet) {
                        AddProduct(productDummy: Product(isVisible:false), showingSheet: $showingProductSheet, mode: .new)
                    }
                    .sheet(isPresented: $showingOfferSheet) {
                        AddOffer(showingSheet: $showingOfferSheet, offerDummy: Offer(isVisible:false), mode: .new)
                    }
                }
            }
        }
        .onAppear{
            modelData.fetchProductsData()
            modelData.fetchOffersData()
            modelData.fetchCategoriesData()
        }
    }
    
}

struct MenuList_Previews: PreviewProvider {
    static var previews: some View {
        MenuList()
            .environmentObject(ModelData(menuId: ""))
    }
}

