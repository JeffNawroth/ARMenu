//
//  ProductViewMain.swift
//  ARMenu
//
//  Created by Eren Cicek on 13.01.22.
//

import SwiftUI

struct ProductViewMain: View {
    @ObservedObject var viewModel = ProductsViewModel()
    
    var body: some View {
        NavigationView{
            ForEach(viewModel.products){ product in
                ProductView(product: product)
            
            }
        }
        .onAppear{
            self.viewModel.fetchData()
        }
        
    }
}

struct ProductViewMain_Previews: PreviewProvider {
    static var previews: some View {
        ProductViewMain()
    }
}
