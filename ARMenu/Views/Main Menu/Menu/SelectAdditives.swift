//
//  SelectAdditives.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 01.01.22.
//

import SwiftUI

struct SelectAdditives: View {
    @Binding var selectedAdditives: Set<Additive>
    var additives: [Additive] = Additive.dummyAdditives
    var body: some View {
       
        
            List(additives, id:\.self, selection: $selectedAdditives){ additive in
                Text(additive.name)
            }
            .navigationTitle("Zusatzstoffe")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.editMode, Binding.constant(EditMode.active))
        }
    }

struct SelectAdditives_Previews: PreviewProvider {
    static var previews: some View {
        SelectAdditives(selectedAdditives: .constant(Set([Additive(name: "Süßstoff")])))
    }
}
