//
//  SelectAdditives.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 01.01.22.
//

import SwiftUI

struct SelectAdditives: View {
    @Binding var selections: [String]
    var additives: [String] = Product.dummyAdditives
    @State private var searchText = ""

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
        .searchable(text: $searchText)
        .navigationBarTitle("Zusatzstoffe", displayMode: .inline)

    }
}

struct SelectAdditives_Previews: PreviewProvider {
    static var previews: some View {
        SelectAdditives(selections: .constant(Product.dummyAdditives))
    }
}
