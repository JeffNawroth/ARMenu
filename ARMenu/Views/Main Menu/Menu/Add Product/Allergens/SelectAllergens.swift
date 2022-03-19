//
//  SelectAllergens.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 30.12.21.
//

import SwiftUI


struct SelectAllergens: View {
    
    @EnvironmentObject var modelData: ModelData
    @Binding var selections: [Allergen]
    @State private var searchText = ""
    @State var showingSheet = false

    //Filter search results
    var searchResults: [Allergen] {
            if searchText.isEmpty {
                return modelData.allergens
            } else {
                return modelData.allergens.filter { $0.name.contains(searchText) }
            }
        }
    var body: some View{
        //Show selectable allergens

        List{
            ForEach(searchResults, id:\.self){ allergen in
                MultipleAllergenPicker(allergen: allergen, isSelected: selections.contains{$0.name == allergen.name}){
                    if (selections.contains{$0.name == allergen.name}){
                        selections.removeAll(where: {$0.name == allergen.name})
                    }else{
                        selections.append(allergen)
                    }
                }
            }
            .onDelete{(indexSet) in
                for index in indexSet{
                    let allergenToDelete = modelData.allergens[index]
                    modelData.deleteAllergen(allergenToDelete: allergenToDelete)
                }
            }
        }
        .toolbar{
            //Button to add a new allergen
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet = true

                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showingSheet) {
                    AddAllergen(showingSheet: $showingSheet)
                }

            }
            //Button to change in editmode
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear{
            modelData.fetchAllergensData()
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
            .environmentObject(ModelData(menuId: ""))
    }
}
