//
//  AddAllergen.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 17.01.22.
//

import SwiftUI

struct AddDeclarations: View {
    @State var name: String = ""
    var navigationName: String
    var isAllergen: Bool{
        navigationName == "Allergen"
    }
    
    var disableForm: Bool {
        name.isEmpty
    }
    
    @Binding var showingSheet: Bool
    var body: some View {
        
        NavigationView {
            Form{
                HStack{
                    Text(navigationName)
                        .padding(.trailing)
                    TextField("Name", text: $name)
                }
            
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig"){
                        showingSheet = false
                        if navigationName == "Allergen"{
                            //TODO: Add Allergen to Database
                        }else{
                            //TODO: Add Additive to Database
                        }
                    }
                    .disabled(disableForm)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                      showingSheet = false
                        
                    }

                }
            }
            .navigationTitle(isAllergen ? "neues Allergen": "neuer Zusatzstoff")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddDeclarations_Previews: PreviewProvider {
    static var previews: some View {
        AddDeclarations(navigationName: "Allergen", showingSheet: .constant(true))
    }
}
