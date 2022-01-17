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
    
    var disableForm: Bool {
        productDummy.image == nil ||
        productDummy.name.isEmpty ||
        productDummy.category.isEmpty ||
        productDummy.price == nil ||
        productDummy.description.isEmpty ||
        productDummy.calories == nil ||
        productDummy.fat == nil ||
        productDummy.carbs == nil ||
        productDummy.protein == nil
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
        var calories: Int!
        var fat: Double!
        var carbs: Double!
        var protein: Double!
        var allergens: [String] = []
        var additives: [String] = []
    }
    
    
    
    @State var productDummy = ProductDummy()
    
    
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
                        ForEach(Product.categories, id: \.self){
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
                        TextField("0", value: $productDummy.calories, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        
                    }
                    HStack{
                        Text("Fett")
                        TextField("0", value: $productDummy.fat, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                        
                        
                    }
                    HStack{
                        Text("Kohlenhydrate")
                        TextField("0", value: $productDummy.carbs, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack{
                        Text("Protein")
                        TextField("0", value: $productDummy.protein, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
                
                Section(header: Text("Allergene")){
                    
                    ForEach(productDummy.allergens, id:\.self){
                        Text($0)
                    }
                    
                    NavigationLink{
                        SelectAllergens(selections: $productDummy.allergens)
                    } label:{
                        Text("Allergene hinzufügen")
                            .foregroundColor(.blue)
                    }
                    
                    
                }
                
                Section(header: Text("Zusatzstoffe")){
                    ForEach(productDummy.additives,id:\.self){
                        Text($0)
                    }
                    
                    NavigationLink{
                        SelectAdditives(selections: $productDummy.additives)
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
                                nutritionFacts: NutritionFacts(calories: productDummy.calories, fat: productDummy.fat, carbs: productDummy.carbs, protein: productDummy.protein),
                                allergens:productDummy.allergens,
                                additives: productDummy.additives
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
        AddProduct(showingSheet: .constant(true))
            .environmentObject(ModelData())
    }
}
