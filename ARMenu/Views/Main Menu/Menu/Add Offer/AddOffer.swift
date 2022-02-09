//
//  AddOffer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 10.01.22.
//

import SwiftUI

struct AddOffer: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingImagePicker = false
    @Binding var showingSheet: Bool
    @State private var inputImage: UIImage?
    
    var disableForm: Bool{
        offerDummy.image==nil||offerDummy.title.isEmpty||offerDummy.description.isEmpty||offerDummy.products.isEmpty
    }
    
    struct OfferDummy{
        var image: UIImage!
        var title: String = ""
        var description: String = ""
        var products: [Product] = []
        var isVisible: Bool = false
    }
    
    @State var offerDummy = OfferDummy()
    
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    VStack{
                        if(offerDummy.image != nil){
                            Image(uiImage: offerDummy.image)
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
                    Toggle("Veröffentlichen", isOn: $offerDummy.isVisible)
                }
                
                
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
                    
                    let sortedProducts = offerDummy.products.sorted{
                        $0.name < $1.name
                    }
                    
                    
                    
                    NavigationLink{
                  SelectProducts(selections: $offerDummy.products)
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
                                            offerDummy.products.removeAll{
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
                        offerDummy.products.remove(atOffsets: IndexSet)
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
 
                        let offer = Offer(image: "", title: offerDummy.title, description: offerDummy.description, products: offerDummy.products, isVisible: offerDummy.isVisible)
                        
                        modelData.addOfferController(offerToAdd: offer, imageToAdd: offerDummy.image)
                        
                        
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
        offerDummy.image = inputImage
    }
}
    struct AddOffer_Previews: PreviewProvider {
        static var previews: some View {
            AddOffer(showingSheet: .constant(true))
        }
    }
