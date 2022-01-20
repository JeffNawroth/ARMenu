//
//  ProductViewMain.swift
//  ARMenu
//
//  Created by Eren Cicek on 13.01.22.
//

import SwiftUI
import FirebaseStorage

struct ProductViewMain: View {
    
    @StateObject var viewModel = ProductsViewModel()
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var inputImage: UIImage?
    @State var download_image:UIImage?
    @State var imageURL = URL(string: "")
    
    
//    var offer = Offer(image: "", title: "WinterSpecial", description: "Wildes Winterangebot für alle", products: [Product(image: "", name: "Eichelkuchen", category: "Kuchen", price: 5.4, description: "Eichelkuchen", isVegan: true, isBio: true, isFairtrade: true, nutritionFacts: NutritionFacts(calories: 2, fat: 2, carbs: 2, protein: 2), allergens: ["Milch", "Käse"], additives: ["Süßstoffe", "Farbstoffe"])])
//
    var product = Product(image: "", name: "uploadTest", price: 5.4, description: "testKuchen", isVegan: true, isBio: true, isFairtrade: true, nutritionFacts: NutritionFacts(calories: 2, fat: 2, carbs: 2, protein: 2))
    
    var body: some View {
        NavigationView{
            ScrollView{
//                Button("Offer hinzufügen"){
//                    viewModel.addOffer(offerToAdd: offer)
//                }
                
                ForEach(viewModel.products){ product in
                    VStack{
                        ProductView(product: product)
                            .padding()
                        Button("Löschen"){
                            viewModel.deleteProduct(productToDelete: product)
                        }
                        
                    }}
                VStack{
                    Button(action: {
                        self.showActionSheet = true
                    }) {
                        Text("Show Image Picker")
                    }.actionSheet(isPresented: $showActionSheet){
                        ActionSheet(title: Text("Chose a picture"), message: nil, buttons: [
                            //Button1
                            
                            .default(Text("Camera"), action: {
                                self.showImagePicker = true
                                
                            }),
                            //Button2
                            .default(Text("Photo Library"), action: {
                                self.showImagePicker = true
                                
                            }),
                            
                            //Button3
                            .cancel()
                            
                        ])
                    }.sheet(isPresented: $showImagePicker){
                        ImagePicker(image: self.$inputImage)
                        
                    }
                    if inputImage != nil {
                        Image(uiImage: inputImage!)
                            .resizable()
                            .scaledToFit()
                            .frame(width:120, height:120)
                    }
                    Text("\(imageURL?.absoluteString ?? "placeholder")")
                    
                    Button("addProduct"){
//                        viewModel.uploadImage(image: inputImage!, imageName: product.name)
                        viewModel.addProductController(productToAdd: product, imageToAdd: inputImage!)
                        
                    }
                    
                    
                    
                    //Button for upload
                    Button(action: {
                        if let thisImage = self.inputImage {
                            viewModel.uploadImage(image: thisImage, imageName: "testName")
                        } else {
                            print("")
                        }
                        
                    }){
                        Text("Upload Image")
                    }
                    
                    Button(action: {
                        Storage.storage().reference().child("testKuchen").getData(maxSize: 2 * 1024 * 1024){
                            (imageData, err) in
                            if let err = err {
                                print("an error has occurred - \(err.localizedDescription)")
                            } else {
                                if let imageData = imageData {
                                    self.download_image = UIImage(data: imageData)
                                } else {
                                    print("couldn't unwrap image data image")
                                }
                                
                            }
                        }
                        
                        
                    }){
                        Text("Download Image")
                    }
                }
                
                
                
            }}
        .onAppear{
            self.viewModel.fetchProductsData()
            self.viewModel.fetchOffersData()
            
        }
        
    }
}

//struct ProductViewMain_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductViewMain()
//    }

