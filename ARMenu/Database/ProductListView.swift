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
//                    ForEach(products.allergens){
//                        Text($0.name)
//                    }
                    Text("\(products.price, specifier: "%.2f")")
                    Text(products.description)
                    Text(String(products.isVegan))

                    Text(String(products.isBio))
                    Text(String(products.isFairtrade))
                    
                    
//
                }
            }
        VStack{
        TextField("name", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        TextField("category", text: $category)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
            }
        
        
    }
    
    struct ProductsListView_Preview: PreviewProvider{
        static var previews: some View{
            ProductsListView()
        }
    }
}
