//
//  MenuRow.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct MenuRow: View {
    var product: Product
    var body: some View {
        HStack {
//            product.image
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100)
//                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5){
                
                HStack{
                    Text(product.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                
                HStack{
                    Text("\(product.price, specifier: "%.2f")")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text(product.category.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                
                if product.isVegan||product.isBio||product.isFairtrade{
                    HStack{
                        if product.isVegan{
                            Image("vegan")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                        }

                        if product.isBio{
                            Image("bio")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 26)
                        }

                        if product.isFairtrade{
                            Image("fairtrade")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                        }
                    }
                }
              
                
                
                
            }
            
            Spacer()
        }
    }
}

struct MenuListRow_Previews: PreviewProvider {
    static var previews: some View {
        MenuRow(product: ModelData().products[0])
    }
}
