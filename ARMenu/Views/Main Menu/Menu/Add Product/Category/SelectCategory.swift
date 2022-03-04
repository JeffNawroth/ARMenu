//
//  SelectCategory.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 25.01.22.
//

import SwiftUI

struct SelectCategory: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var selectedCategory: Category
    @Environment(\.presentationMode) var presentationMode
    @State var showingSheet = false
    
    var body: some View {
        List{
            ForEach(modelData.categories){ category in
                CategoryPicker(category: category, isSelected: selectedCategory.name == category.name) {
                    if selectedCategory.name != category.name{
                        selectedCategory = category
                    }else{
                        selectedCategory.name = ""
                    }
                    
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .onDelete{(indexSet) in
                for index in indexSet{
                    let categoryToDelete = modelData.categories[index]
                    modelData.deleteCategory(categoryToDelete: categoryToDelete)
                }
            }
        }
        .navigationTitle("Kategorie")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet = true
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $showingSheet){
                    AddCategory(showingSheet: $showingSheet)
                }
                
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
}

struct SelectCategory_Previews: PreviewProvider {
    static var previews: some View {
        SelectCategory(selectedCategory: .constant(Category(name:"Kuchen")))
    }
}
