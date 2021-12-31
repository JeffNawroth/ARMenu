//
//  SelectAllergens.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 30.12.21.
//

import SwiftUI


struct SelectAllergens: View {

    @Binding var productAllergens: [Allergen]
    var allergens: [Allergen] = ModelData().allergens
    @State var multiSelection = Set<Allergen>()

    


    var body: some View {
            List(allergens,id: \.self, selection: $multiSelection){ allergen in
                    Text(allergen.name)
                    }
                    .navigationTitle("Allergene")
                    .navigationBarTitleDisplayMode(.inline)
                .environment(\.editMode, Binding.constant(EditMode.active))
    }
    
}

struct SelectAllergens_Previews: PreviewProvider {
    static var previews: some View {
        SelectAllergens(productAllergens: .constant(ModelData().allergens))
    }
}
