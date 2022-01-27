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
    var body: some View {
        List{
            ForEach(modelData.units){ unit in
                UnitPicker(unit: unit, isSelected: selectedUnit.name == unit.name) {
                    if selectedUnit != unit{
                        selectedUnit = unit
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            modelData.fetchUnitsData()
        }
    }
}

struct SelectUnit_Previews: PreviewProvider {
    static var previews: some View {
        SelectUnit(selectedUnit: .constant(Unit.dummyUnits[0]), showingUnitsSheet: .constant(true))
    }
}
