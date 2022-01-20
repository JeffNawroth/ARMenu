//
//  MenuList.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct MenuList: View {
    
    @EnvironmentObject var productModelData: ProductModelData
    @State private var showingProductSheet = false
    @State private var showingOfferSheet = false
    @State private var searchText = ""
    @State private var showsConfirmation = false
    @State private var selectedCategory = Category(name: "Alles")
    
    
    var loggedInUser: User = User.dummyUser
    
        var filteredMenuList: [Product] {
            productModelData.products.filter{ product in
                (selectedCategory.name == "Alles" || selectedCategory.name == product.category.name)
            }
        }
    
        var searchResults: [Product] {
            if searchText.isEmpty {
                return filteredMenuList
            } else {
                return filteredMenuList.filter { $0.name.contains(searchText) }
            }
        }
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Picker("Kategorie", selection: $selectedCategory) {
                        Text("Alles").tag(Category(name: "Alles"))
                        ForEach(productModelData.categories, id: \.self) {
                            Text($0.name)
                        }
                    }
                }
                Section(header: Text("Angebote")){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(productModelData.offers){ offer in
                                NavigationLink{
                                    OfferDetail(offer: offer)
                                } label:{
                                    OfferColumn(offer: offer)
                                    
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
                            } label:{
                                MenuRow(product: product)
                            }
                        }.onDelete{(indexSet) in
                            for index in indexSet{
                                let productToDelete = productModelData.products[index]
                                productModelData.deleteProduct(productToDelete: productToDelete)
                            }
                        }
                    }
                    
                }
            }
            .navigationTitle("Speisekarte")
            .searchable(text: $searchText)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    if loggedInUser.role == .Admin{
                        EditButton()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    if loggedInUser.role == .Admin{
                        Button {
                            showsConfirmation = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .confirmationDialog("Was möchten sie tun?", isPresented: $showsConfirmation) {
                            Button("Angebot erstellen"){
                                showingOfferSheet = true
                            }
                            Button("Produkt erstellen"){
                                showingProductSheet = true
                            }
                            
                            Button("Abbrechen", role:.cancel) {}
                            
                        }
                        
                        .sheet(isPresented: $showingProductSheet) {
                            AddProduct(showingSheet: $showingProductSheet)
                        }
                        .sheet(isPresented: $showingOfferSheet) {
                            AddOffer(showingSheet: $showingOfferSheet)
                        }
                    }
                    
                }
            }
        }
        .onAppear{
            productModelData.fetchProductsData()
            
            productModelData.fetchOffersData()
            productModelData.fetchCategoriesData()
        }
    }
}

struct MenuList_Previews: PreviewProvider {
    static var previews: some View {
        MenuList()
            .environmentObject(ProductModelData())
    }
}

