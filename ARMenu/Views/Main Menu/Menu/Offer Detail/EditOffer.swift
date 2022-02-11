//
//  EditOffer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 08.02.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditOffer: View {
    @State var offer: Offer
    @EnvironmentObject var modelData: ModelData
    @State private var showingImagePicker = false
    @Binding var showingSheet: Bool
    @State private var inputImage: UIImage?
    @FocusState private var isFocused: Bool

    
    var body: some View {
        NavigationView{
            List{
                Section{
                    VStack{
                        if(inputImage == nil){
                            AnimatedImage(url: URL(string: offer.image))
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
                    }
                }.listRowBackground(Color.clear)
                
                Section{
                    Toggle("Veröffentlichen", isOn: $offer.isVisible)
                }
                
                
                Section{
                    HStack{
                        Text("Titel")
                        TextField("Titel", text: $offer.title)
                            .multilineTextAlignment(.trailing)
                            .focused($isFocused)

                    }
                }
                
//                Section(header: Text("Beschreibung")){
//                    TextEditor(text: $offer.description)
//                        .focused($isFocused)
//
//                }
                
                Section(header: Text("Produkte")){
                    
                    let sortedProducts = offer.products.sorted{
                        $0.name! < $1.name!
                    }
                    
                    
                    
                    NavigationLink{
                  SelectProducts(selections: $offer.products)
                    } label:{
                        HStack{
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                            
                            Text("Produkte hinzufügen")
                        }
                    }
                    
                    ForEach(sortedProducts, id: \.self){ product in
                            NavigationLink {
                                MenuDetail(product: product)
                            } label: {
                                HStack{
                                    Button(action: {
                                        withAnimation(.spring()){
                                            offer.products.removeAll{
                                                $0 == product
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
                        offer.products.remove(atOffsets: IndexSet)
                    }
                    
                   
                }
            }
            .navigationBarTitle(Text("Angebot bearbeiten"), displayMode: .inline)
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Fertig"){
                        showingSheet = false
                        modelData.updateOfferController(offerToUpdate: offer, imageToUpdate: inputImage)
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Abbrechen"){
                        showingSheet = false
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
        guard inputImage != nil else { return }
    }
}

struct EditOffer_Previews: PreviewProvider {
    static var previews: some View {
        EditOffer(offer: Offer.dummyOffer, showingSheet: .constant(true))
    }
}
