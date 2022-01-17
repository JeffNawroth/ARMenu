//
//  SelectAdditives.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 01.01.22.
//

import SwiftUI

struct SelectAdditives: View {
    
    var additives: [String] = Product.dummyAdditives

    @Binding var selections: [String]
    @State private var searchText = ""
    @State var showingSheet = false


    var searchResults: [String] {
            if searchText.isEmpty {
                return additives
            } else {
                return additives.filter { $0.contains(searchText) }
            }
        }
    var body: some View {
        List{
            ForEach(searchResults, id:\.self){ additive in
                MultipleSelectionPicker(title: additive, isSelected: selections.contains(additive)){
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
                    AddDeclarations(navigationName: "Zusatzstoff", showingSheet: $showingSheet)
                }

            }
        }
        .searchable(text: $searchText)
        .navigationBarTitle("Zusatzstoffe", displayMode: .inline)

    }
}

struct SelectAdditives_Previews: PreviewProvider {
    static var previews: some View {
        SelectAdditives(selections: .constant(Product.dummyAdditives))
    }
}
