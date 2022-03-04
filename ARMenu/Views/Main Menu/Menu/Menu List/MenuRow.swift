//
//  MenuRow.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MenuRow: View {
    var product: Product
    var body: some View {
        HStack {
            if let image = product.image{
                AnimatedImage(url: URL(string: image))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .cornerRadius(8)
            }
            else{
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .foregroundColor(.gray)
            }
            
            
            VStack(alignment: .leading, spacing: 3){
                
                
                if let category = product.category{
                    Text(category.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text(product.name!)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                
               
                        HStack{
                            if let price = product.price{
                                Text("\(price, specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)


                            }
                            if product.price != nil && product.servingSizes != nil && product.servingSizes?.count == 1{
                                Text("•")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            if let servingSizes = product.servingSizes{
                                if servingSizes.count == 1{
                                    if let servingSize = servingSizes.first{
                                        Text("\(servingSize.size!) \(servingSize.unit!.name)")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                }
                               
                            }


                        }
                   
                
                
               
                
                if (product.isVegan != nil || product.isBio != nil || product.isFairtrade != nil){
                    HStack{
                        if let isVegan = product.isVegan{
                            if isVegan{
                                Image("vegan")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                            }
                        }
                        
                        if let isBio = product.isBio{
                            if isBio{
                                Image("bio")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 26)
                            }
                        }
                        
                        
                        if let isFairtrade = product.isFairtrade{
                            if isFairtrade{
                                Image("fairtrade")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                            }
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
        MenuRow(product: Product.dummyProduct)
        
    }
}
