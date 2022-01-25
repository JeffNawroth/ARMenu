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
    @Binding var showingCategorySheet: Bool
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
                        showingCategorySheet = false
                        modelData.addCategory(categoryToAdd: category)
                    }
                    .disabled(disableForm)

                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                      showingCategorySheet = false
                        
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
        AddCategory(showingCategorySheet: .constant(true))
    }
}
