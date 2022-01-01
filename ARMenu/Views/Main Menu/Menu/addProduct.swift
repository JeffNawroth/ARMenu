//
//  addFood.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct addProduct: View {
    
    var dummyCategories:[String] = ["Alles", "Kuchen", "Eis", "Getränk","Waffel"]

    @EnvironmentObject var modelData: ModelData
    @Binding var showingSheet: Bool
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var disableForm: Bool {
        productDummy.name.isEmpty || productDummy.price == nil || productDummy.description.isEmpty || productDummy.image == nil || productDummy.category.isEmpty || nutritionFactsDummy.calories == nil || nutritionFactsDummy.fat == nil || nutritionFactsDummy.carbs == nil || nutritionFactsDummy.protein == nil
    }
    
    
    struct NutritionFactsDummy{
        var calories: Int!
        var fat: Double!
        var carbs: Double!
        var protein: Double!
        
    }
    
    struct ProductDummy{
        var image: Image!

        var name: String = ""
        var category: String = ""
        var price: Double!
        var description: String = ""
        
        var isVegan: Bool = false
        var isBio: Bool = false
        var isFairtrade: Bool = false
        
        var nutritionFacts: NutritionFacts!
        var allergens: Set<Allergen> = Set<Allergen>()
        var additives: Set<Additive> = Set<Additive>()
    }
    
    
    
    @State var productDummy = ProductDummy()
    @State var nutritionFactsDummy = NutritionFactsDummy()

    
    
    var body: some View {
        
        NavigationView{
            List{
                Section{
                    VStack{
                        if productDummy.image != nil{
                            productDummy.image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                            
                        }else{
                            
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
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
                    Picker("Kategorie", selection: $productDummy.category) {
                        ForEach(dummyCategories, id: \.self){
                            Text($0)
                        }
                    }
                    HStack{
                        Text("Name")
                        TextField("Name", text: $productDummy.name)
                            .multilineTextAlignment(.trailing)
                        
                        
                    }
                    HStack{
                        Text("Preis")
                        TextField("0", value: $productDummy.price, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
                
                Section(header: Text("Beschreibung")){
                    TextEditor(text: $productDummy.description)
                }
                
                Section(header: Text("Zertifikate")){
                    Toggle(isOn: $productDummy.isVegan) {
                        Text("Vegan")
                    }
                    Toggle(isOn: $productDummy.isBio) {
                        Text("Bio")
                    }
                    Toggle(isOn: $productDummy.isFairtrade) {
                        Text("Fairtrade")
                    }
                }
                
                Section(header: Text("Nährwerte")){
                    HStack{
                        Text("Kalorien")
                        TextField("0", value: $nutritionFactsDummy.calories, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        
                    }
                    HStack{
                        Text("Fett")
                        TextField("0", value: $nutritionFactsDummy.fat, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        
                        
                    }
                    HStack{
                        Text("Kohlenhydrate")
                        TextField("0", value: $nutritionFactsDummy.carbs, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack{
                        Text("Protein")
                        TextField("0", value: $nutritionFactsDummy.protein, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
                
                Section(header: Text("Allergene")){
                    
                    ForEach(Array(productDummy.allergens)){
                            Text($0.name)
                    }
                    
                    NavigationLink{
                        SelectAllergens(selectedAllergens: $productDummy.allergens)
                    } label:{
                       Text("Allergene hinzufügen")
                            .foregroundColor(.blue)
                    }

                   
                }
                
                Section(header: Text("Zusatzstoffe")){
                    ForEach(Array(productDummy.additives)){
                        Text($0.name)
                    }
                    
                    NavigationLink{
                        SelectAdditives(selectedAdditives: $productDummy.additives)
                    } label:{
                       Text("Zusatzstoffe hinzufügen")
                            .foregroundColor(.blue)
                    }
                }
                
                
            }
            .navigationBarTitle(Text("neues Produkt"), displayMode: .inline)
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = false
                        
                        
                        let product: Product =
                        Product(image: productDummy.image,
                                name: productDummy.name,
                                category: productDummy.category,
                                price: productDummy.price,
                                description: productDummy.description,
                                isVegan: productDummy.isVegan,
                                isBio: productDummy.isBio,
                                isFairtrade: productDummy.isFairtrade,
                                nutritionFacts: NutritionFacts(calories: nutritionFactsDummy.calories, fat: nutritionFactsDummy.fat, carbs: nutritionFactsDummy.carbs, protein: nutritionFactsDummy.protein),
                                allergens: Array(productDummy.allergens),
                                additives: Array(productDummy.additives)
                                
                        )
                        
                        modelData.products.append(product)
                        
                    } label: {
                        Text("Fertig")
                        
                    }
                    .disabled(disableForm)
                    
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
        productDummy.image = Image(uiImage: inputImage)
    }
}

struct addFood_Previews: PreviewProvider {
    static var previews: some View {
        addProduct(showingSheet: .constant(true))
    }
}
