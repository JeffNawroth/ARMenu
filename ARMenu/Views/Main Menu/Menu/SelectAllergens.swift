//
//  SelectAllergens.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 30.12.21.
//

import SwiftUI


struct SelectAllergens: View {
    @Binding var selectedAllergens: Set<Allergen>
    var allergens: [Allergen] = Allergen.dummyAllergens
    
    var body: some View {
        List(allergens, id:\.self, selection: $selectedAllergens){
            Text($0.name)
        }
        .navigationTitle("Allergene")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.editMode, Binding.constant(EditMode.active))
    }
}
        
    
struct SelectAllergens_Previews: PreviewProvider {
        static var previews: some View {
            SelectAllergens(selectedAllergens: .constant(Set([Allergen(name: "Ei")])))
        }
    }
