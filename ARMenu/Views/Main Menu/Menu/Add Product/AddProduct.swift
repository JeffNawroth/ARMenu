//
//  addFood.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct AddProduct: View {
    
    
    @EnvironmentObject var modelData: ModelData
    @Binding var showingSheet: Bool
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @FocusState private var isFocused: Bool
    var disableForm: Bool {
        productDummy.image == nil ||
        productDummy.name.isEmpty ||
        productDummy.category.name.isEmpty ||
        productDummy.price == nil ||
        productDummy.description.isEmpty ||
        productDummy.calories == nil ||
        productDummy.fat == nil ||
        productDummy.carbs == nil ||
        productDummy.protein == nil
    }
    
    struct ProductDummy{
        var image: UIImage!
        var name: String = ""
        var category: Category = Category(name:"")
        var price: Double!
        var description: String = ""
        var isVegan: Bool = false
        var isBio: Bool = false
        var isFairtrade: Bool = false
        var isVisible = false
        var calories: Int!
        var fat: Double!
        var carbs: Double!
        var protein: Double!
        var allergens: [Allergen] = []
        var additives: [Additive] = []
        var toppings: [Topping] = []
        
    }
    
    @State var productDummy = ProductDummy()
    
    
    var body: some View {
        
        NavigationView{
            List{
                Section{
                    VStack{
                        if productDummy.image != nil{
                            Image(uiImage: productDummy.image)
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
                    Toggle("Veröffentlichen", isOn: $productDummy.isVisible)
                }
                
                Section{
                    NavigationLink {
                        SelectCategory(selectedCategory: $productDummy.category)
                    } label: {
                        HStack{
                            Text("Kategorie")
                            Spacer()
                            Text(productDummy.category.name)
                                .foregroundColor(.gray)
                        }
                    }

                    
                    HStack{
                        Text("Name")
                        TextField("Name", text: $productDummy.name)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                        
                        
                    }
                    HStack{
                        Text("Preis")
                        TextField("0", value: $productDummy.price, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                    }
                    
                }
                
                Section(header: Text("Beschreibung")){
                    TextEditor(text: $productDummy.description)
                        .focused($isFocused)
                    
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
                        TextField("0", value: $productDummy.calories, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                        
                    }
                    HStack{
                        Text("Fett")
                        TextField("0", value: $productDummy.fat, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                        
                        
                    }
                    HStack{
                        Text("Kohlenhydrate")
                        TextField("0", value: $productDummy.carbs, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                    }
                    
                    HStack{
                        Text("Protein")
                        TextField("0", value: $productDummy.protein, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                    }
                    
                }
                
                Section(header: Text("Toppings")){
                    NavigationLink{
                        SelectToppings(selections: $productDummy.toppings)
                    } label:{
                        Text("Toppings hinzufügen")
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(productDummy.toppings,id:\.self){ topping in
                        HStack{
                            Text(topping.name)
                            Spacer()
                            Text("+ \(topping.price, specifier: "%.2f")")
                        }
                    }
                    
                }
                
                Section(header: Text("Allergene")){
                    NavigationLink{
                        SelectAllergens(selections: $productDummy.allergens)
                    } label:{
                        Text("Allergene hinzufügen")
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(productDummy.allergens, id:\.self){
                        Text($0.name)
                    }
                }
                
                Section(header: Text("Zusatzstoffe")){
                    
                    NavigationLink{
                        SelectAdditives(selections: $productDummy.additives)
                    } label:{
                        Text("Zusatzstoffe hinzufügen")
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(productDummy.additives,id:\.self){
                        Text($0.name)
                    }
                    
                    
                }
                
                
            }
            .navigationTitle("neues Produkt")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onAppear{
                modelData.fetchCategoriesData()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = false
                        
                        
                        let product: Product =
                        Product(image: "",
                                name: productDummy.name,
                                category: productDummy.category,
                                price: productDummy.price,
                                description: productDummy.description,
                                isVegan: productDummy.isVegan,
                                isBio: productDummy.isBio,
                                isFairtrade: productDummy.isFairtrade, isVisible: productDummy.isVisible, nutritionFacts: NutritionFacts(calories: productDummy.calories, fat: productDummy.fat, carbs: productDummy.carbs, protein: productDummy.protein),
                                allergens:productDummy.allergens,
                                additives: productDummy.additives,
                                toppings: productDummy.toppings
                        )
                        
                        modelData.addProductController(productToAdd: product, imageToAdd: productDummy.image)
                        
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
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button {
                        isFocused = false
                        
                    } label: {
                        Image(systemName:"keyboard.chevron.compact.down")
                    }
                }
            }
            
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        productDummy.image = inputImage
    }
}

struct addFood_Previews: PreviewProvider {
    static var previews: some View {
        AddProduct(showingSheet: .constant(true))
            .environmentObject(ModelData())
    }
}
