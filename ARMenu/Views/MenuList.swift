//
//  MenuList.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct MenuList: View {
    @State var modelData: ModelData
    @State private var showCategoryOnly: String = "Alles"
    @State private var selectedTab: String = "Liste"
    @State private var showingSheet = false
    
    var filteredMenuList: [Product] {
        modelData.products.filter{ food in
            (showCategoryOnly == "Alles" || showCategoryOnly == food.category)
        }
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Picker("Kategorie", selection: $showCategoryOnly) {
                        ForEach(modelData.categories, id: \.self){
                            Text($0)
                        }
                    }
                }
                Section{
                    List{
                        ForEach(filteredMenuList){ food in
                            NavigationLink{
                                MenuDetail(product: food)
                            } label:{
                                MenuRow(product: food)
                            }
                        } .onDelete{ (indexSet) in modelData.products.remove(atOffsets: indexSet)}
                    }
                }
            }
            .navigationTitle("Speisekarte")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        showingSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }

                    .sheet(isPresented: $showingSheet) {
                        addFood(modelData: $modelData,showingSheet: $showingSheet)
                    }
                }
            }
        }
    }
}

struct MenuList_Previews: PreviewProvider {
    static var previews: some View {
        MenuList(modelData: ModelData())
    }
}

