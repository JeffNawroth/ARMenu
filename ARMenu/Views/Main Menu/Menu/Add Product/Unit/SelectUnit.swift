//
//  SelectUnit.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 26.01.22.
//

import SwiftUI

struct SelectUnit: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedUnit: Unit
    @Binding var showingUnitsSheet: Bool
    @State var showingSheet = false
    var body: some View {
        NavigationView{
            List{
                ForEach(modelData.units){ unit in
                    UnitPicker(unit: unit, isSelected: selectedUnit.name == unit.name) {
                        if selectedUnit != unit{
                            selectedUnit = unit
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .onDelete{(indexSet) in
                    for index in indexSet{
                        let unitToDelete = modelData.units[index]
                        modelData.deleteUnit(unitToDelete: unitToDelete)
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
                        AddUnit(showingSheet: $showingSheet)
                    }

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
            }
            .onAppear {
                modelData.fetchUnitsData()
            }
            .navigationTitle("Einheit")
            .navigationBarTitleDisplayMode(.inline)
        }
       
            
    }
}

struct SelectUnit_Previews: PreviewProvider {
    static var previews: some View {
        SelectUnit(selectedUnit: .constant(Unit.dummyUnits[0]), showingUnitsSheet: .constant(true))
    }
}
