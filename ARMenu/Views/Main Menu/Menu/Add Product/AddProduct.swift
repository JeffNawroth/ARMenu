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
    @State private var showingUnitsSheet = false
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
        var isVisible = false

        var image: UIImage!
        var name: String = ""
        var category: Category = Category(name:"")
        var unit: Unit = Unit(name: "l")
        var size: Double!
        var price: Double!
        
        var description: String = ""
        
        var isVegan: Bool = false
        var isBio: Bool = false
        var isFairtrade: Bool = false
        
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
            Form{
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
                HStack{
                    Text("Name")
                    TextField("Name", text: $productDummy.name)
                        .multilineTextAlignment(.trailing)
                        .focused($isFocused)                 
                }
                                        
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
                        Button {
                            showingUnitsSheet = true
                        } label: {
                            HStack{
                                Text(productDummy.unit.name)
                                    .foregroundColor(.blue)
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                                Divider()
                            }
                        }.padding(.trailing)
                        .buttonStyle(.plain)

                        TextField("Menge", value: $productDummy.size, format: .number)
                            .keyboardType(.decimalPad)
                    }
                .sheet(isPresented: $showingUnitsSheet) {
                    SelectUnit(selectedUnit: $productDummy.unit, showingUnitsSheet: $showingUnitsSheet)
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
                
//                Section(){
//
//                        ForEach(servingSizeViews, id: \.self){ view in
//                            view
//                        }
//                        .onDelete { offsets in
//                            servingSizeViews.remove(atOffsets: offsets)
//                        }
//                        HStack{
//                            Button {
//                                servingSizeViews.append(ServingSizeView())
//                            } label: {
//                                Image(systemName: "plus.circle.fill")
//                                    .foregroundColor(.green)
//                            }
//                            Text("Serviergröße hinzufügen")
//
//                        }
//
//                }
                
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
                    
                    ForEach(productDummy.toppings,id:\.self){ topping in
                        HStack{
                            Text(topping.name)
                            Spacer()
                            Text("+ \(topping.price, specifier: "%.2f")")
                        }
                    }
                    .onDelete { IndexSet in
                        productDummy.toppings.remove(atOffsets: IndexSet)
                    }
                    
                    NavigationLink{
                        SelectToppings(selections: $productDummy.toppings)
                    } label:{
                        HStack{
                            Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            
                            Text("Toppings hinzufügen")
                        }
                    }
                }
                
                Section(header: Text("Allergene")){
                    
                    ForEach(productDummy.allergens, id:\.self){
                        Text($0.name)
                    }
                    .onDelete { IndexSet in
                        productDummy.allergens.remove(atOffsets: IndexSet)
                    }
                    
                    
                    NavigationLink{
                        SelectAllergens(selections: $productDummy.allergens)
                    } label:{
                        HStack{
                            Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            
                            Text("Allergene hinzufügen")
                        }
                        
                    }
                    
                }
                
                Section(header: Text("Zusatzstoffe")){
                    
                    ForEach(productDummy.additives,id:\.self){
                        Text($0.name)
                    }
                    .onDelete { IndexSet in
                        productDummy.additives.remove(atOffsets: IndexSet)
                    }
                    
                    NavigationLink{
                        SelectAdditives(selections: $productDummy.additives)
                    } label:{
                        HStack{
                            Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            
                            Text("Zusatzstoffe hinzufügen")
                        }
                           
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
                                servingSize: ServingSize(unit: productDummy.unit, size: productDummy.size), isVegan: productDummy.isVegan,
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
