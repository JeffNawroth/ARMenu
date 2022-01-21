//
//  AddOffer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 10.01.22.
//

import SwiftUI

struct AddOffer: View {
    @EnvironmentObject var productModelData: ProductModelData
    @State private var showingImagePicker = false
    @Binding var showingSheet: Bool
    @State private var inputImage: UIImage?
    
    var disableForm: Bool{
        offerDummy.image==nil||offerDummy.title.isEmpty||offerDummy.description.isEmpty||offerDummy.products.isEmpty
    }
    
    struct OfferDummy{
        var image: Image!
        var title: String = ""
        var description: String = ""
        var products: [Product] = []
    }
    
    @State var offerDummy = OfferDummy()
    
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    VStack{
                        if(offerDummy.image != nil){
                            offerDummy.image
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
                    HStack{
                        Text("Titel")
                        TextField("Titel", text: $offerDummy.title)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Beschreibung")){
                    TextEditor(text: $offerDummy.description)
                }
                
                Section(header: Text("Produkte")){
                    
                    
                    NavigationLink{
                  SelectProducts(selections: $offerDummy.products)
                    } label:{
                       Text("Produkte hinzufügen")
                            .foregroundColor(.blue)
                    }
                    
                    ForEach(offerDummy.products){ product in
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
 
                        let offer = Offer(image: "", title: offerDummy.title, description: offerDummy.description, products: offerDummy.products)
                        
                        productModelData.addOffer(offerToAdd: offer)
                        
                        
                    }
                    .disabled(disableForm)
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
        guard let inputImage = inputImage else { return }
        offerDummy.image = Image(uiImage: inputImage)
    }
}
    struct AddOffer_Previews: PreviewProvider {
        static var previews: some View {
            AddOffer(showingSheet: .constant(true))
        }
    }
