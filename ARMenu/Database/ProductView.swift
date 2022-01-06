//
//  ProductView.swift
//  ARMenu
//
//  Created by Eren Cicek on 05.01.22.
//

import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI
import CoreMedia

struct ProductView : View{
    
    @ObservedObject var products = getProductData()
    @State var name = ""
    @State var description = ""
    
    var body: some View{
        
        VStack{
            
            if self.products.data.count != 0{
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 15){
                        
                        ForEach(self.products.data){i in
                            
                            VStack{
                                
                                AnimatedImage(url: URL(string: i.image)).resizable().frame(height: 270)
                                
                                HStack{
                                    
                                    VStack(alignment: .leading){
                                        
                                        Text(i.name)
                                            .font(.title)
                                            .fontWeight(.heavy)
                                        
                                        Text("\(i.price, specifier: "%.2f")")
                                            .font(.body)
                                            .fontWeight(.heavy)
                                        
                                        Button(action:{
                                            //Delete Product
                                            products.deleteData(productToDelete: i)
                                            },
                                            label: {
                                                Image(systemName: "minus.circle")
                                                    })
                                                .buttonStyle(BorderlessButtonStyle())
                                        
                                    }
                                    
                            }
                                
                        }
                    }
                    
                }
            }
                VStack{
                TextField("name", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                    //Add Button
                Button(action: {
        
                    // call addData()
                    products.addData(name: name, image: "", price: 0, description: description, isVegan: true, isBio: false, isFairtrade: true)
        
                    //clear the TextFields
                   name = ""
                   description = ""
        
                }, label:{
                        Text("add Product")
                })
                }
                
//                .onAppear(){
////                                self.viewModel.fetchData()
//                                self.products.getData()
//        }
    }
        }}

struct ProductView_Previews: PreviewProvider {
    static var previews: some View{
        ProductView()
    }
    
}
}
