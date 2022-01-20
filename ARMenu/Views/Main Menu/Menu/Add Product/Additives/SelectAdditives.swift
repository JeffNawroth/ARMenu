//
//  SelectAdditives.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 01.01.22.
//

import SwiftUI

struct SelectAdditives: View {
    
    @EnvironmentObject var productModelData: ProductModelData
    @Binding var selections: [Additive]
    @State private var searchText = ""
    @State var showingSheet = false


    var searchResults: [Additive] {
            if searchText.isEmpty {
                return productModelData.additives
            } else {
                return productModelData.additives.filter { $0.name.contains(searchText) }
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
        }
        .onAppear{
            productModelData.fetchAdditivesData()
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
    }
}
