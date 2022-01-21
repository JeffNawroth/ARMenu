//
//  AddAllergen.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.01.22.
//

import SwiftUI

struct AddAllergen: View {
    @EnvironmentObject var productModelData: ModelData
    @State var allergen:Allergen = Allergen(name: "")
    
    var disableForm: Bool {
        allergen.name.isEmpty
    }
    
    @Binding var showingSheet: Bool
    var body: some View {
        
        NavigationView {
            Form{
                HStack{
                    Text("Allergen")
                        .padding(.trailing)
                    TextField("Name", text: $allergen.name)
                }
            
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig"){
                        showingSheet = false
                            productModelData.addAllergen(allergenToAdd: allergen)
                    }
                    .disabled(disableForm)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                      showingSheet = false
                        
                    }

                }
            }
            .navigationTitle("neues Allergen")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddAllergen_Previews: PreviewProvider {
    static var previews: some View {
        AddAllergen(showingSheet: .constant(true))
    }
}
