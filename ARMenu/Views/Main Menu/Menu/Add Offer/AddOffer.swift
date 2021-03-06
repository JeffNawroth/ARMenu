//
//  AddOffer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 10.01.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddOffer: View {
    
    @EnvironmentObject var modelData: ModelData
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var showingImageConfirmation = false
    @FocusState private var isFocused: Bool
    @Binding var showingSheet: Bool
    @State var disableButton = false
    @State var offerDummy: Offer
    enum Mode{
        case new
        case edit
    }
    
    //Filter products that are assigned to an offer based on the Id
    var products: [Product]{
            modelData.products.filter{
                offerDummy.products != nil && offerDummy.products!.contains($0.id!)
            }
        }
    
    var mode: Mode
    
    var body: some View {
        NavigationView{
            ZStack{
                List{
                    Section{
                        VStack{
                            //Show image
                            if let image = image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                    .onTapGesture {
                                        showingImageConfirmation = true
                                        
                                    }
                            }
                            else if let image = offerDummy.image{
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
                                if offerDummy.image == nil && image == nil{
                                    showingImagePicker = true
                                }else{
                                    showingImageConfirmation = true

                                }
                                
                            } label: {
                                Text("Foto hinzuf??gen")
                                    .foregroundColor(Color.blue)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }.listRowBackground(Color.clear)
                    
                    Section{
                        Toggle("Ver??ffentlichen", isOn: $offerDummy.isVisible.toNonOptionalBoolean())
                    }
                    
                    
                    Section{
                        HStack{
                            Text("Titel")
                            TextField("Titel", text: $offerDummy.title.toNonOptionalString())
                                .multilineTextAlignment(.trailing)
                                .focused($isFocused)
                            
                        }
                    }
                    
                    Section(header: Text("Beschreibung")){
                        TextEditor(text: $offerDummy.description.toNonOptionalString())
                            .focused($isFocused)
                        
                    }
                    
                    Section(header: Text("Produkte")){
                        
                        
                        
                        
                        
                        NavigationLink{
                            SelectProducts(selections: $offerDummy.products.toNonOptionalStrings())
                        } label:{
                            HStack{
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.green)
                                
                                Text("Produkte hinzuf??gen")
                            }
                        }
                        
                        
                        
                        //Sort products by alphabet
                        if let products = products{
                            let sortedProducts = products.sorted{
                                $0.name! < $1.name!
                            }

                            //Show products and button to delete
                            ForEach(sortedProducts, id: \.self){ product in
                                NavigationLink {
                                    MenuDetail(product: product)
                                } label: {
                                    HStack{
                                        Button(action: {
                                            withAnimation(.spring()){
                                                offerDummy.products?.removeAll{
                                                    $0 == product.id
                                                }
                                            }
                                        }, label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundColor(Color.red)
                                        })
                                            .buttonStyle(.borderless)

                                        MenuRow(product: product)
                                    }
                                }
                            }
                            .onDelete { IndexSet in
                                offerDummy.products?.remove(atOffsets: IndexSet)
                            }
                            
                        }
                        
                        
                        
                    }
                    
                }
                //Loading screen for adding or updating a new Offer 
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
            
            .navigationBarTitle(mode == .new ? Text("neues Angebot"): Text("Angebot bearbeiten"))
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: inputImage) { _ in loadImage() }
            .onChange(of: modelData.loading){_ in if !modelData.loading{showingSheet = false}}
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .toolbar{
                //Buttons to save the offer or to cancel
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Fertig"){
                        disableButton = true
                        reset()
                        if mode == .new{
                            modelData.addOfferController(offerToAdd: offerDummy, imageToAdd: inputImage)
                        }else{
                            modelData.updateOfferController(offerToUpdate: offerDummy, imageToUpdate: inputImage)
                        }
                        
                        
                    }
                    .disabled( offerDummy.title == nil)
                    .disabled(disableButton)
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Abbrechen"){
                        showingSheet = false
                    }
                    .disabled(disableButton)
                }
                
                
                //Button to close the keyboard manually after an input
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button {
                        isFocused = false
                        
                    } label: {
                        Image(systemName:"keyboard.chevron.compact.down")
                    }
                }
            }
            //Query whether to add a new image from the gallery or delete the existing image
            .confirmationDialog("", isPresented: $showingImageConfirmation) {
                Button("Fotobibliothek ??ffnen"){
                    showingImagePicker = true
                }
                if  inputImage != nil || offerDummy.image != nil {
                    Button("L??schen", role: .destructive){
                        inputImage = nil
                        image = nil
                        offerDummy.image = nil
                    }
                }
                
            }
        }
    }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    //Update values if they are empty
    func reset(){
        if let products = offerDummy.products{
            if products.isEmpty{
                offerDummy.products = nil
            }
        }
        if let description = offerDummy.description{
            if description.isEmpty{
                offerDummy.description = nil
            }
        }
    }
}
struct AddOffer_Previews: PreviewProvider {
    static var previews: some View {
        AddOffer(showingSheet: .constant(true), offerDummy: Offer.dummyOffer, mode: .new)
    }
}
