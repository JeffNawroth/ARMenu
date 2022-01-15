//
//  MultipleSelectionRow.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 15.01.22.
//

import SwiftUI

struct MultipleSelectionPicker: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(self.title)
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }.foregroundColor(.primary)
    }
}

struct MultipleSelectionRow_Previews: PreviewProvider {
    static var previews: some View {
        MultipleSelectionPicker(title: "Allergen", isSelected: true) {
        }
    }
}
