//
//  addFood.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import SDWebImageSwiftUI


struct AddProduct: View {
    
    
    @EnvironmentObject var modelData: ModelData
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingUnitsSheet = false
    @State private var showingImageConfirmation = false
    @State private var showingARPreview = false
    @State private var fileURL: URL?
    @State private var showingFileImporter = false
    @State private var disableButtons = false
     private var disableButton:Bool{
         var value: Bool = false
        if let servingSizes = productDummy.servingSizes{
            for servingSize in servingSizes {
                if servingSize.unit == nil || servingSize.price == nil || servingSize.size == nil{
                   
                    value =  true
                }
                else{value =  false}
            }
        }else{
            value =  false
        }
         return value
    }
    @State var productDummy: Product
    @FocusState private var isFocused: Bool
    @Binding var showingSheet: Bool
    @State var loading = false
    enum Mode{
        case new
        case edit
    }
    var mode: Mode
    
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
                                
                            }else if let image = productDummy.image{
                                AnimatedImage(url: URL(string: image))
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                    .onTapGesture {
                                        showingImageConfirmation = true
                                    }
                            }
                            else{
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        showingImagePicker = true
                                    }
                            }
                            
                            Button {
                                if productDummy.image == nil && image == nil{
                                    showingImagePicker = true
                                }else{
                                    showingImageConfirmation = true

                                }
                                
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
                                
                                Spacer()
                                
                                Button{
                                    
                                }label:{
                                    Image(systemName: "questionmark")
                                    
                                }
                                .buttonStyle(.borderless)
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
                                    showingARPreview = true
                                } label: {
                                    Image(systemName: "eye")
                                }
                                .buttonStyle(.borderless)
                            }
                        }else if let url = productDummy.model{
                            HStack{
                                Button{
                                    withAnimation(.spring()) {
                                        productDummy.model = nil
                                    }
                                }label: {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(Color.red)
                                }
                                .buttonStyle(.borderless)
                                Text(URL(string: url)!.lastPathComponent)
                                Spacer()
                                Button {
                                    showingARPreview = true
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
                            Text("Preis")
                            TextField("0", value: $productDummy.price, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                            
                        }
                        
                    }
                    
            
                    if productDummy.servingSizes != nil{
                        ForEach($productDummy.servingSizes.toNonOptionalServingSizes(), id: \.servingSizeId){ $servingSize in
                            HStack{
                                Button{
                                    withAnimation(.spring()){
                                        productDummy.servingSizes?.removeAll{
                                            $0.servingSizeId == servingSize.servingSizeId
                                        }
                                        if productDummy.servingSizes?.count == 0{
                                            productDummy.servingSizes = nil
                                        }
                                    }
                                }label:{
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                                ServingSizeView(servingSize: $servingSize,isFocused: _isFocused)
                            }
                            
                        }
                        .onDelete { IndexSet in
                            productDummy.servingSizes?.remove(atOffsets: IndexSet)
                        }
                        
                    }
                    
                    HStack{
                        Button {
                            if productDummy.servingSizes != nil {
                                productDummy.servingSizes?.append(ServingSize())
                            }
                            else{
                                productDummy.servingSizes = []
                                productDummy.servingSizes?.append(ServingSize())

                            }
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                        }
                        Text("Serviergröße hinzufügen")
                    }
                    
                    
                    
                    
                    
                    Section(header: Text("Beschreibung")){
                        TextEditor(text: $productDummy.description.toNonOptionalString())
                            .focused($isFocused)
                    }
                    
                    
                    
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
            .navigationTitle(mode == .new ? "neues Produkt": "Produkt bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: inputImage) { _ in loadImage() }
            .onChange(of: modelData.loading){_ in if !modelData.loading{showingSheet = false}}
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .sheet(isPresented: $showingARPreview){
                if mode == .new{
                    ARPreview(url: fileURL!)
                        .ignoresSafeArea()
                    
                }
                else{
                    ZStack{
                        ARViewContainer(product: productDummy, loading: $loading)
                            .ignoresSafeArea()
                        
                        if loading{
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
                }
                
            }
            .onAppear{
                modelData.fetchCategoriesData()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                        disableButtons = true
                        
                        
                        reset()
               
    
                        
                        if mode == .new{
                            modelData.addProductController(productToAdd: productDummy, imageToAdd: inputImage, modelToAdd: fileURL)
                            
                        }
                        else{
                            modelData.updateProductController(productToUpdate: productDummy, imageToUpdate: inputImage, modelToUpdate: fileURL)
                        }
                        
                        
                    } label: {
                        Text("Fertig")
                        
                    }
                    .disabled(productDummy.name == nil)
                    .disabled(disableButtons)
                    .disabled(disableButton)
                    
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSheet = false
                    } label: {
                        Text("Abbrechen")
                    }
                    .disabled(disableButtons)
                    
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
                if  inputImage != nil || productDummy.image != nil {
                    Button("Löschen", role: .destructive){
                        inputImage = nil
                        image = nil
                        productDummy.image = nil
                    }
                }
                
            }
            
            
        }
        
    }
    
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        
    }
    
    func reset(){
        if let allergens = productDummy.allergens{
            if allergens.isEmpty{
                productDummy.allergens = nil
            }
        }
        if let additives = productDummy.additives{
            if additives.isEmpty{
                productDummy.additives = nil
            }
        }
        
        if let toppings = productDummy.toppings{
            if toppings.isEmpty{
                productDummy.toppings = nil
            }
        }
        if let nutritionFacts = productDummy.nutritionFacts{
            if (nutritionFacts.calories == nil && nutritionFacts.carbs == nil && nutritionFacts.protein == nil && nutritionFacts.fat == nil){
                productDummy.nutritionFacts = nil
            }
        }
        if let description = productDummy.description{
            if description.isEmpty{
                productDummy.description = nil
            }
        }
        if let category = productDummy.category{
            if category.name.isEmpty{
                productDummy.category = nil
            }
        }
        
        if let bio = productDummy.isBio{
            if !bio{
                productDummy.isBio = nil
            }
        }
        
        if let fairtrade = productDummy.isFairtrade{
            if !fairtrade{
                productDummy.isFairtrade = nil
            }
        }
        
        if let vegan = productDummy.isVegan{
            if !vegan{
                productDummy.isVegan = nil
            }
        }
    }
}

struct AddProduct_Previews: PreviewProvider {
    static var previews: some View {
        AddProduct(productDummy: Product.dummyProduct, showingSheet: .constant(true), mode: .new)
            .environmentObject(ModelData(menuId: ""))
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






