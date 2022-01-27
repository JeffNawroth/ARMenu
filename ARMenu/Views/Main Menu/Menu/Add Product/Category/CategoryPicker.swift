//
//  CategoryPicker.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 25.01.22.
//

import SwiftUI

struct CategoryPicker: View {
    var category: Category
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(category.name)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }.foregroundColor(.primary)
    }
}

struct CategoryPicker_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPicker(category: Category(name:"Test"), isSelected: true) {
            
        }
    }
}
