//
//  SelectAllergens.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 30.12.21.
//

import SwiftUI


struct SelectAllergens: View {
    
    var allergens: [String] = Product.dummyAllergens
    @Binding var selections: [String]
    @State private var searchText = ""
    @State var showingSheet = false

    var searchResults: [String] {
            if searchText.isEmpty {
                return allergens
            } else {
                return allergens.filter { $0.contains(searchText) }
            }
        }
    var body: some View{
        List{
            ForEach(searchResults, id:\.self){ allergen in
                MultipleSelectionPicker(title: allergen, isSelected: selections.contains(allergen)){
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
                    AddDeclarations(navigationName: "Allergen", showingSheet: $showingSheet)
                }

            }
        }
       
        .searchable(text: $searchText)
        .navigationTitle("Allergene")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
        
        
    }
    
}

struct SelectAllergens_Previews: PreviewProvider {
    static var previews: some View {
        SelectAllergens(selections: .constant(Product.dummyAllergens))
    }
}
