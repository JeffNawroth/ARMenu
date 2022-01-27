//
//  AddCategory.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 24.01.22.
//

import SwiftUI

struct AddCategory: View {
    
    @EnvironmentObject var modelData: ModelData
    @State var category:Category = Category(name: "")
    @Binding var showingSheet: Bool
    var disableForm: Bool {
        category.name.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form{
                HStack{
                    Text("Kategorie")
                        .padding(.trailing)
                    TextField("Name", text: $category.name)
                }
            
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fertig"){
                        showingSheet = false
                        modelData.addCategory(categoryToAdd: category)
                    }
                    .disabled(disableForm)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                      showingSheet = false
                        
                    }

                }
            }
            .navigationTitle("neue Kategorie")
        .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddCategory_Previews: PreviewProvider {
    static var previews: some View {
        AddCategory(showingSheet: .constant(true))
    }
}
