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
                    }
                }
                
                Section(header: Text("Beschreibung")){
                    TextEditor(text: $offer.description)
                }
                
                Section(header: Text("Produkte")){
                    
                    
                    NavigationLink{
                  SelectProducts(selections: $offer.products)
                    } label:{
                       Text("Produkte hinzufügen")
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(offer.products, id: \.self){ product in
                            NavigationLink {
                                MenuDetail(product: product)
                            } label: {
                                MenuRow(product: product)
                            }
                    }
                }
            }
            .navigationBarTitle(Text("neues Angebot"), displayMode: .inline)
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button("Fertig"){
                        showingSheet = false
                        modelData.updateOffersDataController(offerToUpdate: offer, imageToUpdate: inputImage)
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Abbrechen"){
                        showingSheet = false
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
