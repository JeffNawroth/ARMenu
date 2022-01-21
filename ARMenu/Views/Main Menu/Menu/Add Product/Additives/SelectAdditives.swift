//
//  SelectAdditives.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 01.01.22.
//

import SwiftUI

struct SelectAdditives: View {
    
    @EnvironmentObject var modelData: ModelData
    @Binding var selections: [Additive]
    @State private var searchText = ""
    @State var showingSheet = false


    var searchResults: [Additive] {
            if searchText.isEmpty {
                return modelData.additives
            } else {
                return modelData.additives.filter { $0.name.contains(searchText) }
            }
        }
    var body: some View {
        List{
            ForEach(searchResults, id:\.self){ additive in
                MultipleAdditivePicker(additive: additive, isSelected: selections.contains(additive)){
                    if selections.contains(additive){
                        selections.removeAll(where: {$0 == additive})
                    }else{
                        selections.append(additive)
                    }
                }
            }.onDelete{(indexSet) in
                for index in indexSet{
                    let additiveToDelete = productModelData.additives[index]
                    productModelData.deleteAdditive(additiveToDelete: additiveToDelete)
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
                    AddAdditive(showingSheet: $showingSheet)
                }

            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            
        }
        .onAppear{
            modelData.fetchAdditivesData()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationTitle("Zusatzstoffe")
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(.plain)

    }
}

struct SelectAdditives_Previews: PreviewProvider {
    
    static var previews: some View {
        SelectAdditives(selections: .constant(Additive.dummyAdditives))
            .environmentObject(ProductModelData())
    }
}
