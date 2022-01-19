//
//  SelectAllergens.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 30.12.21.
//

import SwiftUI


struct SelectAllergens: View {
    
    @EnvironmentObject var productModelData: ProductModelData
    @Binding var selections: [Allergen]
    @State private var searchText = ""
    @State var showingSheet = false

    var searchResults: [Allergen] {
            if searchText.isEmpty {
                return productModelData.allergens
            } else {
                return productModelData.allergens.filter { $0.name.contains(searchText) }
            }
        }
    var body: some View{
        List{
            ForEach(searchResults, id:\.self){ allergen in
                MultipleAllergenPicker(allergen: allergen, isSelected: selections.contains(allergen)){
                    if selections.contains(allergen){
                        selections.removeAll(where: {$0 == allergen})
                    }else{
                        selections.append(allergen)
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet = true

                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showingSheet) {
                    //AddProduct(showingSheet: $showingSheet)
                    AddAllergen(showingSheet: $showingSheet)
                }

            }
        }
        .onAppear{
            productModelData.fetchAllergensData()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Allergene")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        
        
    }
    
}

struct SelectAllergens_Previews: PreviewProvider {
    static var previews: some View {
        SelectAllergens(selections: .constant(Allergen.dummyAllergens))
    }
}
