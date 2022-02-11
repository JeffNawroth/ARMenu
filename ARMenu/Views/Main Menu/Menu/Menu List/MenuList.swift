//
//  MenuList.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct MenuList: View {
    
    @EnvironmentObject var modelData: ModelData
    @State private var showingProductSheet = false
    @State private var showingOfferSheet = false
    @State private var searchText = ""
    @State private var showsConfirmation = false
    @State private var showsOfferConfirmation = false
    @State private var selectedCategory = Category(name: "Alles")
    @State private var mode: EditMode = .inactive
    
    
    var filteredMenuList: [Product] {
        modelData.products.filter{ product in
            (selectedCategory.name == "Alles" || selectedCategory.name == product.category?.name)
        }
    }
    
    var searchResults: [Product] {
        if searchText.isEmpty {
            return filteredMenuList
        } else {
            return filteredMenuList.filter { $0.name!.contains(searchText) /*|| $0.category.name.contains(searchText)*/}
        }
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Picker("Kategorie", selection: $selectedCategory) {
                        Text("Alles").tag(Category(name: "Alles"))
                        ForEach(modelData.categories, id: \.self) {
                            Text($0.name)
                        }
                    }
                }
                Section(header: Text("Angebote")){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(modelData.offers){ offer in
                                NavigationLink{
                                    OfferDetail(offer: offer)
                                        .opacity(offer.isVisible ? 1: 0.25)
                                    
                                } label:{
                                    
                                    OfferColumn(offer: offer, mode: $mode){
                                        withAnimation(.spring()){
                                            showsOfferConfirmation  = true
                                        }
                                    }
                                    .confirmationDialog("Dieses Angebot wirklich löschen?", isPresented: $showsOfferConfirmation, titleVisibility: .visible) {
                                        
                                        Button("Löschen", role: .destructive){
                                            modelData.deleteOffer(offerToDelete: offer)
                                        }
                                        
                                    }
                                    .opacity(offer.isVisible ? 1: 0.25)
                                    
                                }
                                
                                
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                }.listRowBackground(Color.clear)
                
                Section(header: Text("Produkte")){
                    List{
                        ForEach(searchResults){ product in
                            NavigationLink{
                                MenuDetail(product: product)
                                    .opacity(product.isVisible ? 1: 0.25)
                            } label:{
                                MenuRow(product: product)
                                    .opacity(product.isVisible ? 1: 0.25)
                            }
                        }.onDelete{(indexSet) in
                            for index in indexSet{
                                let productToDelete = modelData.products[index]
                                modelData.deleteProduct(productToDelete: productToDelete)
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("Speisekarte")
            .searchable(text: $searchText)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                    
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showsConfirmation = true
                    } label: {
                        Image(systemName: "plus")
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
                        AddProduct(showingSheet: $showingProductSheet)
                    }
                    .sheet(isPresented: $showingOfferSheet) {
                        AddOffer(showingSheet: $showingOfferSheet)
                    }
                }
            }
            .environment(\.editMode, $mode)
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
            .environmentObject(ModelData())
    }
}

