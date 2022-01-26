//
//  UnitPicker.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 26.01.22.
//

import SwiftUI

struct UnitPicker: View {
    var unit: Unit
    var isSelected: Bool
    var action: () -> Void
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(unit.name)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }.foregroundColor(.primary)
    }
}

struct UnitPicker_Previews: PreviewProvider {
    static var previews: some View {
        UnitPicker(unit: Unit.dummyUnits[0], isSelected: true){
            
        }
    }
}
