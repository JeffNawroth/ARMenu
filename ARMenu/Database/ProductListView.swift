//
//  ProductListView.swift
//  ARMenu
//
//  Created by Eren Cicek on 02.01.22.
//

import Foundation
import SwiftUI
import Firebase


struct ProductsListView: View {
    
    @ObservedObject private var viewModel = ProductsViewModel()
    
    @State var name = ""
    @State var category = ""
    
    var body: some View {
        
        
            List(viewModel.products){ products in
                VStack(){
                    
                    Text(products.name)
                    Text(products.category)
                    Text("\(products.price, specifier: "%.2f")")
                    Text(products.description)
                    Text(String(products.isVegan))
                    Text(String(products.nutritionFacts.calories))
                    Text(String(products.isBio))
                    Text(String(products.isFairtrade))
                    
                    //Update Data
                    Button(action:{
                        //Delete Product
                        viewModel.updateData(productToUpdate: products)
                    },
                           label: {
                                Image(systemName: "pencil")
                    })
                        .buttonStyle(BorderlessButtonStyle())
                    
                    //Delete Button
                    Button(action:{
                        //Delete Product
                        viewModel.deleteData(productToDelete: products)
                    },
                           label: {
                                Image(systemName: "minus.circle")
                    })
                        .buttonStyle(BorderlessButtonStyle())
                    
                }
            }
        VStack{
        TextField("name", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("category", text: $category)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
            //Add Button
        Button(action: {

            // call addData()
            viewModel.addData(name: name, category: category, price: 0, description: "", isVegan: true, isBio: false, isFairtrade: true)

            //clear the TextFields
           name = ""
           category = ""

        }, label:{
                Text("add Product")
        })
        }
                           
            .onAppear(){
//                self.viewModel.fetchData()
                self.viewModel.getData()
            }
        
        
    }
    struct ProductsListView_Preview: PreviewProvider{
        static var previews: some View{
            ProductsListView()
        }
    }
}
