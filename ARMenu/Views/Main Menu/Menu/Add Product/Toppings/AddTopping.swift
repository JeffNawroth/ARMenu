//
//  AddTopping.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 18.01.22.
//

import SwiftUI

struct AddTopping: View {
    
    @EnvironmentObject var modelData: ModelData
    
    struct ToppingDummy{
        var name: String = ""
        var price: Double!
    }
    
    @State var toppingDummy = ToppingDummy()

    @Binding var showingSheet: Bool
   private var disableForm: Bool{
       toppingDummy.name.isEmpty
    }
    var body: some View {
        NavigationView {
            Form{
                HStack{
                    Text("Topping")
                    TextField("Name", text: $toppingDummy.name)
                        .multilineTextAlignment(.trailing)

                }
                HStack{
                    Text("Preis")
                    TextField("0", value: $toppingDummy.price, format: .number)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
            
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig"){
                        showingSheet = false
                        let topping: Topping = Topping(name: toppingDummy.name, price: toppingDummy.price)
                        
                        modelData.addTopping(toppingToAdd: topping)
                    }
                    .disabled(disableForm)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                      showingSheet = false
                        
                    }

                }
            }
            .navigationTitle("neues Topping")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddTopping_Previews: PreviewProvider {
    static var previews: some View {
        AddTopping(showingSheet: .constant(true))
    }
}
