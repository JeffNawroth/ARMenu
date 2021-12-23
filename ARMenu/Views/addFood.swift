//
//  addFood.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct addFood: View {
   
    @Binding var modelData: ModelData
    @Binding var showingSheet: Bool
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    
    
    struct FoodDummy{
        var imagaName: String = ""
        var name: String = ""
        var category: String = ""
        var price: Double?
        var description: String = ""
        var image: Image?
        
        var nutritionFacts: NutritionFacts?
        
        var isVegan: Bool = false
        var isFairtade: Bool = false
        var isBio: Bool = false


    }
    
    @State var foodDummy = FoodDummy()
    
    var body: some View {
    
        NavigationView{
            List{
                Section{
                    VStack{
                        if foodDummy.image != nil{
                            foodDummy.image?
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .shadow(radius: 3)
                            
                        }else{
                            
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                        }
                        
                        Button {
                            showingImagePicker = true

                        } label: {
                            Text("Foto hinzufügen")
                                .foregroundColor(Color.blue)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }.listRowBackground(Color.clear)
                
                Section{
                    Picker("Kategorie", selection: $foodDummy.category) {
                        ForEach(modelData.categories, id: \.self){
                            Text($0)
                        }
                    }
                    TextField("Name", text: $foodDummy.name)
                    TextField("Preis", value: $foodDummy.price, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Beschreibung")){
                    TextEditor(text: $foodDummy.description)
                }
                
                Section{
                    Toggle(isOn: $foodDummy.isVegan) {
                            Text("Vegan")
                    }
                }
            }
            .navigationBarTitle(Text("neues Essen"), displayMode: .inline)
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = false
                     
                        
                        let product: Product = Product(name: foodDummy.name, category: foodDummy.category, price: foodDummy.price!, description: foodDummy.description, image: foodDummy.image!, isVegan: foodDummy.isVegan, nutritionFacts: foodDummy.nutritionFacts!, isBio: foodDummy.isFairtade, isFairtrade: foodDummy.isBio)
                        
                        modelData.products.append(product)
                        
                    } label: {
                        Text("Fertig")
                        
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSheet = false
                    } label: {
                        Text("Abbrechen")
                    }

                }
            }

        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        foodDummy.image = Image(uiImage: inputImage)
    }
}

struct addFood_Previews: PreviewProvider {
    static var previews: some View {
        addFood(modelData: .constant(ModelData()), showingSheet: .constant(true))
    }
}
