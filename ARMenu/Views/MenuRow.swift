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
            product.image
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 5){
                    Text(product.name)
                        .font(.title2)
                        .fontWeight(.semibold)
      
          
                
                HStack{
                    Text("\(product.price, specifier: "%.2f")")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text(product.category)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    
                }
                
                HStack{
                  
                    if product.isVegan{
                        Image("v-label")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }
                    
                    if product.isBio{
                        Image("bio")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }
                    
                    if product.isFairtrade{
                        Image("fairtrade")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17)
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
