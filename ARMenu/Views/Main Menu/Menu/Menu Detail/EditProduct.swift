//
//  EditProduct.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 07.02.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditProduct: View {
    @EnvironmentObject var modelData: ModelData
    @State var product: Product
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingUnitsSheet = false
    @State private var fileURL: URL?
    @State private var openFile = false
    @FocusState private var isFocused: Bool
    @Binding var showingSheet: Bool
    
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    VStack{
                        if inputImage == nil{
                            AnimatedImage(url: URL(string: product.image))
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .shadow(radius: 3)
                                .onTapGesture {
                                    showingImagePicker = true
                                }
                            
                        }else{
                            
                            Image(uiImage: inputImage!)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .shadow(radius: 3)
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
                    
                    
                    if (fileURL == nil){
                        
                        Text(URL(string:product.model)!.lastPathComponent)
                    }else{
                        Text(fileURL!.lastPathComponent)
                    }
                }
                
                Section{
                    Toggle("Veröffentlichen", isOn: $product.isVisible)
                }
                
                
                Section{
                    HStack{
                        Text("Name")
                        TextField("Name", text: $product.name)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                    }
                    
                    NavigationLink {
                        SelectCategory(selectedCategory: $product.category)
                    } label: {
                        HStack{
                            Text("Kategorie")
                            Spacer()
                            Text(product.category.name)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    
                    
                    HStack{
                        Button {
                            showingUnitsSheet = true
                        } label: {
                            HStack{
                                Text(product.servingSize.unit.name)
                                    .foregroundColor(.blue)
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                                    .foregroundColor(.gray)
                                Divider()
                            }
                        }.padding(.trailing)
                            .buttonStyle(.plain)
                        
                        TextField("Menge", value: $product.servingSize.size, format: .number)
                            .keyboardType(.decimalPad)
                    }
                    .sheet(isPresented: $showingUnitsSheet) {
                        SelectUnit(selectedUnit: $product.servingSize.unit, showingUnitsSheet: $showingUnitsSheet)
                    }
                    
                    
//                    HStack{
//                        Text("Preis")
//                        TextField("0", value: $product.price, format: .number)
//                            .keyboardType(.decimalPad)
//                            .multilineTextAlignment(.trailing)
//                            .focused($isFocused)
//
//                    }
                    NumberTextField(name: "Preis", value: $product.price, isFocused: _isFocused)
                }
                
                Section(header: Text("Beschreibung")){
                    ZStack{
                        TextEditor(text: $product.description)
                            .focused($isFocused)
                        Text(product.description).opacity(0).padding(.all, 8)
                    }
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
                    
                    Toggle("Vegan", isOn: $product.isVegan)
                    Toggle("Bio", isOn: $product.isBio)
                    Toggle("Fairtrade", isOn: $product.isFairtrade)

                    
                   
//                    Toggle(isOn: $product.isVegan) {
//                        Text("Vegan")
//                    }
//                    Toggle(isOn: $product.isBio) {
//                        Text("Bio")
//                    }
//                    Toggle(isOn: $product.isFairtrade) {
//                        Text("Fairtrade")
//                    }
                }
                
                Section(header: Text("Nährwerte")){
                    
                    HStack{
                        Text("Kalorien")
                        TextField("0", value: $product.nutritionFacts.calories, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)
                    }
                    
                    NumberTextField(name: "Fett", value: $product.nutritionFacts.fat, isFocused: _isFocused)
                    NumberTextField(name: "Kohlenhydrate", value: $product.nutritionFacts.carbs, isFocused: _isFocused)
                    NumberTextField(name: "Protein", value: $product.nutritionFacts.protein, isFocused: _isFocused)
                    
                    //                    HStack{
                    //                        Text("Fett")
                    //                        TextField("0", value: $product.nutritionFacts.fat, format: .number)
                    //                            .keyboardType(.decimalPad)
                    //                            .multilineTextAlignment(.trailing)
                    //                            .focused($isFocused)
                    //                    }
                    
                    
                    
                    
                    //                    HStack{
                    //                        Text("Kohlenhydrate")
                    //                        TextField("0", value: $product.nutritionFacts.carbs, format: .number)
                    //                            .keyboardType(.decimalPad)
                    //                            .multilineTextAlignment(.trailing)
                    //                            .focused($isFocused)
                    //
                    //                    }
                    
                    //                    HStack{
                    //                        Text("Protein")
                    //                        TextField("0", value: $product.nutritionFacts.protein, format: .number)
                    //                            .keyboardType(.decimalPad)
                    //                            .multilineTextAlignment(.trailing)
                    //                            .focused($isFocused)
                    //
                    //                    }
                    
                }
                
                Section(header: Text("Toppings")){
                    
                    let sortedToppings = product.toppings.sorted{
                        $0.name < $1.name
                    }
                    
                    NavigationLink{
                        SelectToppings(selections: $product.toppings)
                    } label:{
                        HStack{
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            
                            Text("Toppings hinzufügen")
                        }
                    }
                    
                    ForEach(sortedToppings,id:\.self){ topping in
                        HStack{
                            
                            Button(action: {
                                withAnimation(.spring()){
                                    product.toppings.removeAll{
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
                        product.toppings.remove(atOffsets: IndexSet)
                    }
                    
                    
                }
                
                Section(header: Text("Allergene")){

                    let sortedAllergens = product.allergens.sorted{
                        $0.name < $1.name
                    }

                    NavigationLink{
                        SelectAllergens(selections: $product.allergens)
                    } label:{
                        HStack{
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)

                            Text("Allergene hinzufügen")
                        }

                    }

                    ForEach(sortedAllergens, id:\.self){ allergen in
                        HStack{
                            Button(action: {
                                withAnimation(.spring()){
                                    product.allergens.removeAll{
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
                        product.allergens.remove(atOffsets: IndexSet)
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
            .navigationTitle("Produkt bearbeiten")
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
                      //  modelData.updateData(productToUpdate: product)
                        modelData.updateProductController(productToUpdate: product, imageToUpdate: inputImage, modelToUpdate: fileURL)
                        
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
        // product.image = inputImage
    }
}

struct EditProduct_Previews: PreviewProvider {
    static var previews: some View {
        EditProduct(product: Product.dummyProduct, showingSheet: .constant(true))
            .environmentObject(ModelData())
    }
}

struct NumberTextField: View{
    var name: String
    @Binding var value: Double
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

