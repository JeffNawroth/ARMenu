//
//  ServingSizeView.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 19.02.22.
//

import SwiftUI

struct ServingSizeView: View, Identifiable {
    var id: UUID = UUID()
    @State private var showingUnitsSheet = false
    @Binding var servingSize: ServingSize
    @EnvironmentObject var modelData: ModelData
    @FocusState  var isFocused: Bool

    var body: some View {
        HStack{
            Button {
                showingUnitsSheet = true
            } label: {
                HStack{
                    Text(servingSize.unit?.name ?? "")
                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .foregroundColor(.gray)
                    Divider()
                }
            }.padding(.trailing)
                .buttonStyle(.plain)
            
            TextField("Menge", value: $servingSize.size , format: .number)
                .keyboardType(.decimalPad)
                .focused($isFocused)


            Divider()

            HStack{
                TextField("Preis", value: $servingSize.price, format: .number)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)



                Spacer()
                Text("€")
            }
            
               
        }
        .sheet(isPresented: $showingUnitsSheet) {
            SelectUnit(selectedUnit: $servingSize.unit.toNonOptionalUnit(), showingUnitsSheet: $showingUnitsSheet)
        }
       
    }
}

struct ServingSizeView_Previews: PreviewProvider {
    static var previews: some View {
        ServingSizeView(servingSize: .constant(ServingSize.dummyServingSizes[0]))
    }
}
