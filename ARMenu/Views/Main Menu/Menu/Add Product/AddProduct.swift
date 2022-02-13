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
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingUnitsSheet = false
    @State private var showingImageConfirmation = false
    @State private var fileURL: URL?
    @State private var showingFileImporter = false
    @State private var disableButton = false
    @State var productDummy = Product(isVisible: false)
    @State var product: Product?
    @FocusState private var isFocused: Bool
    @Binding var showingSheet: Bool
    
    var body: some View {
        
        NavigationView{
            ZStack{
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
                                        showingImageConfirmation = true
                                    }
                                
                            }else{
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        showingImageConfirmation = true
                                    }
                            }
                            
                            Button {
                                showingImageConfirmation = true

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
                            if showingFileImporter{
                                showingFileImporter = false
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
                                        showingFileImporter = true
                                    })
                            }else{
                                showingFileImporter = true
                            }
                        } label: {
                            HStack{
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                
                                Text("3D-Model hinzufügen")
                            }
                        }
                        .disabled(fileURL != nil)
                        
                        if let url = fileURL {
                            HStack{
                                Button{
                                    withAnimation(.spring()) {
                                        fileURL = nil
                                    }
                                }label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(Color.red)
                                }
                                .buttonStyle(.borderless)
                                Text(url.lastPathComponent)
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
                        Toggle("Veröffentlichen", isOn: $productDummy.isVisible.toNonOptionalBoolean())
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
                        Toggle("Vegan", isOn: $productDummy.isVegan.toNonOptionalBoolean())
                        Toggle("Bio", isOn: $productDummy.isBio.toNonOptionalBoolean())
                        Toggle("Fairtrade", isOn: $productDummy.isFairtrade.toNonOptionalBoolean())
                    }
                    
                    Section(header: Text("Nährwerte")){

                        HStack{
                            Text("Kalorien")
                            
                            TextField("0", value: $productDummy.nutritionFacts.toNonOptionalNutritionFacts().calories, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                            
                        }
                        
                        NutritionTextField(name: "Fett", value:  $productDummy.nutritionFacts.toNonOptionalNutritionFacts().fat, isFocused: _isFocused)
                        NutritionTextField(name: "Kohlenhydrate", value:  $productDummy.nutritionFacts.toNonOptionalNutritionFacts().carbs, isFocused: _isFocused)
                        NutritionTextField(name: "Protein", value:  $productDummy.nutritionFacts.toNonOptionalNutritionFacts().protein, isFocused: _isFocused)
                        
                    }
                    Group{
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
                
                if modelData.loading{
                    ZStack{
                        Color(.systemBackground)
                            .ignoresSafeArea()
                            .opacity(0.8)
                        
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(3)
                    }
                }
            }
            .fileImporter(isPresented: $showingFileImporter, allowedContentTypes: [.usdz]) { res in
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
            .onChange(of: modelData.loading){_ in if !modelData.loading{showingSheet = false}}
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .onAppear{
                modelData.fetchCategoriesData()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {

                        disableButton = true
                       
                        
                        modelData.addProductController(productToAdd: productDummy, imageToAdd: inputImage, modelToAdd: fileURL)
                        
                    } label: {
                        Text("Fertig")
                        
                    }
                    .disabled(productDummy.name == nil)
                    .disabled(disableButton)
                    
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSheet = false
                    } label: {
                        Text("Abbrechen")
                    }
                    .disabled(disableButton)
                    
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
            .confirmationDialog("", isPresented: $showingImageConfirmation) {
                Button("Fotobibliothek öffnen"){
                    showingImagePicker = true
                }
                if  inputImage != nil {
                    Button("Löschen", role: .destructive){
                        inputImage = nil
                        image = nil
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

struct AddProduct_Previews: PreviewProvider {
    static var previews: some View {
        AddProduct(showingSheet: .constant(true))
            .environmentObject(ModelData())
    }
}

struct NutritionTextField: View{
   
    var name: String
    @Binding var value: Double?
    @FocusState  var isFocused: Bool
    var body: some View{
        HStack{
            Text(name)
            TextField("0", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .focused($isFocused)
        }
    }
}

