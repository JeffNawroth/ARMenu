//
//  SelectAllergens.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 30.12.21.
//

import SwiftUI


struct SelectAllergens: View {
    
    var allergens: [String] = Product.dummyAllergens
    @Binding var selections: [String]
    var body: some View{
        List{
            ForEach(allergens, id:\.self){ allergen in
                MultipleSelectionPicker(title: allergen, isSelected: selections.contains(allergen)){
                    if selections.contains(allergen){
                        selections.removeAll(where: {$0 == allergen})
                    }else{
                        selections.append(allergen)
                    }
                }
            }
        }
        
    }
    
}

struct SelectAllergens_Previews: PreviewProvider {
    static var previews: some View {
        SelectAllergens(selections: .constant(Product.dummyAllergens))
    }
}
