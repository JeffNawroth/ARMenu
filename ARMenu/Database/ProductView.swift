import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI
import FirebaseFirestoreSwift
import RealityKit



struct ProductView : View{
    
    //    @ObservedObject var viewModel = ProductsViewModel()
    //    @State var name = ""
    //    @State var description = ""
    var product: Product
    
    
    var body: some View{
        
        VStack{
            VStack{
            Text(product.name)
            Text(product.category)
            Text(String(product.price))
            Text(product.description)
            }
            VStack{
            Text(String((product.isVegan)))
            Text(String((product.isBio)))
            Text(String((product.isFairtrade)))
            }
            VStack{
            Text(String(product.nutritionFacts.calories))
            Text(String(product.nutritionFacts.fat))
            Text(String(product.nutritionFacts.protein))
            Text(String(product.nutritionFacts.carbs))
            }
            VStack{
                ForEach(product.allergens, id: \.self){ allergen in
                    Text(allergen)
                }
                ForEach(product.additives, id: \.self){ additive in
                    Text(additive)
                }
                
            }
        }
        
        
        
        //        NavigationView{
        //                    ForEach(viewModel.products){ product in
        //                        VStack{
        //                        Text(product.name)
        //                        Text(product.category)
        //                        Text("\(product.price)")
        //                        Text(product.description)
        //                        Text("\(product.isVegan)")
        //                        Text("\(product.isBio)")
        //                        Text("\(product.isFairtrade)")
        //                        Text("\(product.nutritionFacts.calories)")
        //                        Text("\(product.nutritionFacts.fat)")
        //                        Text("\(product.nutritionFacts.carbs)")
        //                        Text("\(product.nutritionFacts.protein)")
        //                        }
        ////                        ForEach(product.allergens){ allergen in
        ////                            Text(allergen.name)
        ////                        }
        //
        ////                        ForEach(product.additives){ additive in
        ////                            Text(additive.name)
        ////                        }
        //
        //                    }
        //                    .navigationBarTitle("Produkt")
        //                    .padding(.bottom)
        //                    }
        //                }
        //                .onAppear{
        //                    self.viewModel.fetchData()
        //                }
        //        VStack{
        //
        //                ScrollView(.vertical, showsIndicators: false) {
        //
        //                    VStack(spacing: 15){
        //
        //                        ForEach(viewModel.products){i in
        //
        //                            VStack{
        //
        //                                AnimatedImage(url: URL(string: i.image)).resizable().frame(height: 270)
        //
        //                                HStack{
        //
        //                                    VStack(alignment: .leading){
        //
        //                                        Text(i.name)
        //                                            .font(.title)
        //                                            .fontWeight(.heavy)
        //
        //                                        Text("\(i.price, specifier: "%.2f")")
        //                                            .font(.body)
        //                                            .fontWeight(.heavy)
        //                                        Text(i.category)
        //
        //                                        Text(String(i.nutritionFacts.calories))
        //                                        Text(String(i.nutritionFacts.fat))
        //                                        Text(String(i.nutritionFacts.carbs))
        //                                        Text(String(i.nutritionFacts.protein))
        //
        //
        //
        //                                        Button(action:{
        ////                                            Delete Product
        //                                            viewModel.deleteData(productToDelete: i)
        //                                            },
        //                                            label: {
        //                                                Image(systemName: "minus.circle")
        //                                                    })
        //                                                .buttonStyle(BorderlessButtonStyle())
        //
        ////                                        Update Data
        ////                                        Button(action:{
        ////                                            //Delete Product
        ////                                            viewModel.updateData(productToUpdate: i)
        ////                                        },
        ////                                               label: {
        ////                                                    Image(systemName: "pencil")
        ////                                        })
        ////                                            .buttonStyle(BorderlessButtonStyle())
        //
        //                                    }
        //
        //                            }
        //
        //                        }
        //                    }
        //
        //
        //                }
        //                    .onAppear {
        //                        self.viewModel.fetchData()
        //
        //                    }
        //            }
        //                VStack{
        //                TextField("name", text: $name)
        //                    .textFieldStyle(RoundedBorderTextFieldStyle())
        //                TextField("description", text: $description)
        //                    .textFieldStyle(RoundedBorderTextFieldStyle())
        //
        ////                    Add Button
        //                Button(action: {
        //
        //                    // call addData()
        //                    viewModel.addData(name: name, image: "", price: 0, description: description, isVegan: true, isBio: false, isFairtrade: true, category: "", nutritionFacts: [0], allergens: [""], additives: [""])
        //
        //                    //clear the TextFields
        //                   name = ""
        //                   description = ""
        //
        //                }, label:{
        //                        Text("add Product")
        //                })
        //                }
        //
        //    } }
    }
    
}




//struct ProductView_Previews: PreviewProvider {
//    static var previews: some View{
//        ProductView(product: Product()
//        
//    }
//    
//}

