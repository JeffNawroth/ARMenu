//
//  MultipleSelectionRow.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 15.01.22.
//

import SwiftUI

struct MultipleAdditivePicker: View {
    var additive: Additive
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(additive.name)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }.foregroundColor(.primary)
    }
}

struct MultipleSelectionRow_Previews: PreviewProvider {
    static var previews: some View {
        MultipleAdditivePicker(additive: Additive.dummyAdditives[0], isSelected: true) {
        }
    }
}
