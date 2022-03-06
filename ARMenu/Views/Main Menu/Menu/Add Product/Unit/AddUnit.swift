//
//  AddUnit.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 30.01.22.
//

import SwiftUI

struct AddUnit: View {
    
    @EnvironmentObject var modelData: ModelData
    @State var unit:Unit = Unit(name: "")
    @Binding var showingSheet: Bool
    var disableForm: Bool {
        unit.name.isEmpty
    }
    
    // Add a new Unit
    var body: some View {
        NavigationView {
            Form{
                HStack{
                    Text("Einheit")
                        .padding(.trailing)
                    TextField("Name", text: $unit.name)
                }
            
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig"){
                        showingSheet = false
                        modelData.addUnit(unitToAdd: unit)
                    }
                    .disabled(disableForm)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                      showingSheet = false
                        
                    }

                }
            }
            .navigationTitle("neue Einheit")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddUnit_Previews: PreviewProvider {
    static var previews: some View {
        AddUnit(showingSheet: .constant(true))
    }
}
