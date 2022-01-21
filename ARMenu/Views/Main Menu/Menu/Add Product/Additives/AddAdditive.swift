//
//  AddAdditive.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.01.22.
//

import SwiftUI

struct AddAdditive: View {
    @EnvironmentObject var productModelData: ModelData
    @State var additive:Additive = Additive(name: "")
    
    var disableForm: Bool {
        additive.name.isEmpty
    }
    
    @Binding var showingSheet: Bool
    var body: some View {
        
        NavigationView {
            Form{
                HStack{
                    Text("Zusatzstoff")
                        .padding(.trailing)
                    TextField("Name", text: $additive.name)
                }
            
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig"){
                        showingSheet = false
                        productModelData.addAdditive(additiveToAdd: additive)
                    }
                    .disabled(disableForm)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                      showingSheet = false
                        
                    }

                }
            }
            .navigationTitle("neuer Zusatzstoff")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddAdditive_Previews: PreviewProvider {
    static var previews: some View {
        AddAdditive(showingSheet: .constant(true))
    }
}
