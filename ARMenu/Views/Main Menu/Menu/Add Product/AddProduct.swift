//
//  addFood.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import SceneKit


struct AddProduct: View {
    
    @EnvironmentObject var modelData: ModelData
    @Binding var showingSheet: Bool
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingUnitsSheet = false
    @FocusState private var isFocused: Bool
    
    @State var fileURL: URL?
    @State var openFile = false
    
    var disableForm: Bool {
        inputImage == nil ||
        productDummy.name == nil ||
        fileURL == nil
    }
    
    struct ProductDummy{
        var isVisible = false
        
      //  var modelURL: URL!
        var name: String?
        var category: Category?
        var size: Double!
        var price: Double?
        
        var description: String?
        
        var isVegan: Bool = false
        var isBio: Bool = false
        var isFairtrade: Bool = false
        
        var calories: Int!
        var fat: Double!
        var carbs: Double!
        var protein: Double!
        
        var nutritionFacts: NutritionFacts?
        var servingSize: ServingSize?
        
        
        var allergens: [Allergen]?
        var additives: [Additive]?
        var toppings: [Topping]?
        
        
    }
    
    @State var productDummy = ProductDummy()
    
    
    
    
    var body: some View {
        
        NavigationView{
            Form{
                Section{
                    VStack{
                        if let image = image{
                            image
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
                        
                        Spacer()
                        
                        
                    }
                    
                }.listRowBackground(Color.clear)
                
                
                Section{
                    Button {
                        openFile = true
                    } label: {
                        HStack{
                            Image(systemName: "arkit")
                            Text("AR-Modell hinzufügen")
                        }
                        
                        
                    }
                    
                    if let fileURL = fileURL {
                        HStack{
                            Text(fileURL.lastPathComponent)
                            Spacer()
                            Button {
                                
                            } label: {
                                Image(systemName: "eye")
                            }
                            .buttonStyle(.borderless)
                            
                        }
                    }
                }
                
                Section{
                    Toggle("Veröffentlichen", isOn: $productDummy.isVisible)
                }
                
                
                Section{
                    HStack{
                        Text("Name")
                        TextField("Name", text: $productDummy.name.toNonOptionalString())
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                    }
                    
                    NavigationLink {
                        SelectCategory(selectedCategory: $productDummy.category.toNonOptionalCategory())
                    } label: {
                        HStack{
                            Text("Kategorie")
                            Spacer()
                            Text(productDummy.category?.name ?? "")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack{
                        Button {
                            showingUnitsSheet = true
                        } label: {
                            HStack{
                                if let unitName = productDummy.servingSize?.unit.name{
                                    Text(unitName)
                                        .foregroundColor(.blue)
                                }
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                                Divider()
                            }
                        }.padding(.trailing)
                            .buttonStyle(.plain)
                        
                        TextField("Menge", value: $productDummy.servingSize.toNonOptionalServingSize().size, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                        
                    }
                    .sheet(isPresented: $showingUnitsSheet) {
                        SelectUnit(selectedUnit: $productDummy.servingSize.toNonOptionalServingSize().unit, showingUnitsSheet: $showingUnitsSheet)
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
                    TextEditor(text: $productDummy.description.toNonOptionalString())
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
                    Toggle("Vegan", isOn: $productDummy.isVegan)
                    Toggle("Bio", isOn: $productDummy.isBio)
                    Toggle("Fairtrade", isOn: $productDummy.isFairtrade)
                }
                
                Section(header: Text("Nährwerte")){
                    
                    
                    HStack{
                        Text("Kalorien")
                        
                        TextField("0", value: $productDummy.nutritionFacts.toNonOptionalNutritionFacts().calories, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                    }
                    HStack{
                        Text("Fett")
                        TextField("0", value: $productDummy.nutritionFacts.toNonOptionalNutritionFacts().fat, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                        
                        
                    }
                    HStack{
                        Text("Kohlenhydrate")
                        TextField("0", value: $productDummy.nutritionFacts.toNonOptionalNutritionFacts().carbs, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                    }
                    
                    HStack{
                        Text("Protein")
                        TextField("0", value: $productDummy.nutritionFacts.toNonOptionalNutritionFacts().protein, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                        
                    }
                    
                }
                
                Section(header: Text("Toppings")){
                    
                    
                    
                    
                    
                    NavigationLink{
                        SelectToppings(selections: $productDummy.toppings.toNonOptionalToppings())
                    } label:{
                        HStack{
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            
                            Text("Toppings hinzufügen")
                        }
                    }
                    
                    
                    if let toppings = productDummy.toppings{
                        let sortedToppings = toppings.sorted{
                            $0.name < $1.name
                        }
                        
                        ForEach(sortedToppings,id:\.self){ topping in
                            HStack{
                                
                                Button(action: {
                                    withAnimation(.spring()){
                                        productDummy.toppings?.removeAll{
                                            $0 == topping
                                        }
                                    }
                                    
                                }, label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(Color.red)
                                })
                                    .buttonStyle(.plain)
                                HStack{
                                    Text(topping.name)
                                    Spacer()
                                    Text("+ \(topping.price, specifier: "%.2f")")
                                }
                            }
                            
                        }
                        .onDelete { IndexSet in
                            productDummy.toppings?.remove(atOffsets: IndexSet)
                        }
                    }
                    
                }
                Group{
                    
                    Section(header: Text("Allergene")){
                        
                        NavigationLink{
                            SelectAllergens(selections: $productDummy.allergens.toNonOptionalAllergens())
                        } label:{
                            HStack{
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                
                                Text("Allergene hinzufügen")
                            }
                            
                        }
                        
                        if let allergens = productDummy.allergens{
                            
                            let sortedAllergens = allergens.sorted{
                                $0.name < $1.name
                            }
                            
                            ForEach(sortedAllergens, id:\.self){ allergen in
                                HStack{
                                    Button(action: {
                                        withAnimation(.spring()){
                                            productDummy.allergens?.removeAll{
                                                $0 == allergen
                                            }
                                        }
                                        
                                    }, label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(Color.red)
                                    })
                                        .buttonStyle(.plain)
                                    
                                    Text(allergen.name)
                                }
                                
                            }
                            .onDelete { IndexSet in
                                productDummy.allergens?.remove(atOffsets: IndexSet)
                            }
                        }
                        
                        
                        
                    }
                    
                    Section(header: Text("Zusatzstoffe")){
                        
                        NavigationLink{
                            SelectAdditives(selections: $productDummy.additives.toNonOptionalAdditives())
                        } label:{
                            HStack{
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                
                                Text("Zusatzstoffe hinzufügen")
                            }
                            
                        }
                        if let additives = productDummy.additives{
                            let sortedAdditives = additives.sorted{
                                $0.name < $1.name
                            }
                            
                            ForEach(sortedAdditives,id:\.self){ additive in
                                HStack{
                                    
                                    Button(action: {
                                        withAnimation(.spring()){
                                            productDummy.additives?.removeAll{
                                                $0 == additive
                                            }
                                        }
                                        
                                    }, label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(Color.red)
                                    })
                                        .buttonStyle(.plain)
                                    
                                    Text(additive.name)
                                    
                                }
                            }
                            .onDelete { IndexSet in
                                productDummy.additives?.remove(atOffsets: IndexSet)
                            }
                        }
                        
                        
                    }
                }
                
                
                
            }
            .fileImporter(isPresented: $openFile, allowedContentTypes: [.usdz]) { res in
                do{
                    fileURL = try res.get()
                    
                }
                catch{
                    print("error reading docs")
                    print(error.localizedDescription)
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
                        Product(image: "",model: "",name: productDummy.name,category: productDummy.category,price: productDummy.price,description: productDummy.description,servingSize: productDummy.servingSize, isVegan: productDummy.isVegan,isBio: productDummy.isBio,isFairtrade: productDummy.isFairtrade, isVisible: productDummy.isVisible, nutritionFacts: productDummy.nutritionFacts,allergens:productDummy.allergens,additives: productDummy.additives,toppings: productDummy.toppings)
                        
                        modelData.addProductController(productToAdd: product, imageToAdd: inputImage!, modelToAdd: fileURL!)
                        
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
        image = Image(uiImage: inputImage)
        
    }
}

struct addFood_Previews: PreviewProvider {
    static var previews: some View {
        AddProduct(showingSheet: .constant(true))
            .environmentObject(ModelData())
    }
}
