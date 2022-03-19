//
//  SelectToppings.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 18.01.22.
//

import SwiftUI

struct SelectToppings: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var selections: [Topping]
    @State private var searchText = ""
    @State private var showingSheet = false
    
    //Filter search results
    var searchResults: [Topping] {
        if searchText.isEmpty {
            return modelData.toppings
        } else {
            return modelData.toppings.filter { $0.name.contains(searchText) }
        }
    }

    var body: some View {
        //Show selectable toppings
        List{
            ForEach(searchResults, id: \.self){ topping in
                MultipleToppingPicker(topping: topping, isSelected: selections.contains{
                    $0.name == topping.name
                }){
                    if (selections.contains{$0.name == topping.name}){
                        selections.removeAll(where: {$0.name == topping.name})
                    }else{
                        selections.append(topping)
                    }
                }
            }
            .onDelete{(indexSet) in
                for index in indexSet{
                    let toppingToDelete = modelData.toppings[index]
                    modelData.deleteTopping(toppingToDelete: toppingToDelete)
                }
            }
           
        }
        .toolbar{
            //Button to add a new topping
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet = true

                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showingSheet) {
                    AddTopping(showingSheet: $showingSheet)
                }

            }
            //Button to change in editmode
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear{
            modelData.fetchToppingsData()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Toppings")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)
    }
}

struct SelectToppings_Previews: PreviewProvider {
    static var previews: some View {
        SelectToppings(selections: .constant(Topping.dummyToppings))
    }
}
