//
//  MenuList.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct MenuList: View {
    
    @EnvironmentObject var modelData: ModelData
    @State private var selectedCategory = 0
    @State private var showingSheet = false
    @State private var searchText = ""
    
    var loggedInUser: User = User.dummyUser
    
    var filteredMenuList: [Product]
//    {
//        modelData.products.filter{ product in
//            (modelData.categories[selectedCategory].name == "Alles" || modelData.categories[selectedCategory].name == product.category.name)
//        }
//    }
    
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
                        ForEach(0..<modelData.categories.count){
                            Text(modelData.categories[$0].name)
                        }
                    }
                }
                Section(header: Text("Angebote")){
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(modelData.offers){ offer in
                                NavigationLink{
                                    OfferDetail(offer: offer)
                                } label:{
//                                    OfferColumn(offer: offer)
                                    
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
                        } .onDelete{ (indexSet) in modelData.products.remove(atOffsets: indexSet)}
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
                            showingSheet = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        
                        .sheet(isPresented: $showingSheet) {
                            addProduct(showingSheet: $showingSheet)
                        }
                    }
                    
                }
            }
        }
    }
}

//struct MenuList_Previews: PreviewProvider {
//    static var previews: some View {
////        MenuList()
////            .environmentObject(ModelData())
//    }
//}

