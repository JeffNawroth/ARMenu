//
//  MenuDetail.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MenuDetail: View {
    var product: Product
    @State private var showingARPreview = false
    @State private var nutritionsExpanded = false
    @State private var allergensExpanded = false
    @State private var toppingsExpanded = false
    var body: some View {
        ScrollView{
            AnimatedImage(url: URL(string: product.image))
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
                .shadow(radius: 3)
                .padding()
            
            VStack(alignment: .leading){
                
                HStack{
                    Text(product.name)
                        .font(.title)
                    
                    if product.isVegan{
                        Image("vegan")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                    
                    
                    if product.isBio{
                        Image("bio")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                    
                    if product.isFairtrade{
                        Image("fairtrade")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                    
                }
                
                Spacer()
                
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
                
                Divider()
                
                Button {
                    showingARPreview.toggle()
                }
            label: {
                HStack{
                    
                    Image(systemName: "arkit")
                        .font(.headline)
                    Text("In AR ansehen")
                        .fontWeight(.semibold)
                    
                    
                    
                }
                .foregroundColor(.white)
                .font(.system(size: 19))
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(Color(red: 120/255, green: 172/255, blue: 149/255))
                .cornerRadius(10)
                
            }
            .sheet(isPresented: $showingARPreview) {
                ARViewContainer().edgesIgnoringSafeArea(.all)
            }
                
                Text("Beschreibung")
                    .font(.title2)
                Text(product.description)
            }
            .padding()
            
            VStack{
                
                DisclosureGroup(isExpanded: $toppingsExpanded) {
                    ForEach(product.toppings, id: \.self){topping in
                        HStack{
                            Text(topping.name)
                            Spacer()
                            Text("+ \(topping.price, specifier: "%.2f")")
                        }
                        
                    }
                } label: {
                    Text("Toppings")
                }
                
                DisclosureGroup(isExpanded: $nutritionsExpanded) {
                    HStack{
                        Spacer()
                        Text("pro 100 g")
                            .fontWeight(.semibold)
                        
                    }
                    
                    HStack{
                        Text("Brennwert")
                        Spacer()
                        Text(String(product.nutritionFacts.calories) + " kcal")
                        
                    }
                    
                    HStack{
                        Text("Fett")
                        Spacer()
                        Text(String(product.nutritionFacts.fat) + " g")
                    }
                    HStack{
                        Text("Kohlenhydrate")
                        Spacer()
                        Text(String(product.nutritionFacts.carbs) + " g")
                    }
                    HStack{
                        Text("Protein")
                        Spacer()
                        Text(String(product.nutritionFacts.protein) + " g")
                    }
                    
                } label: {
                    Text("Nährwerte")
                }
                
                DisclosureGroup(isExpanded: $allergensExpanded) {
                    
                    HStack(alignment: .top){
                        
                        VStack(alignment: .leading){
                            Text("Allergene")
                                .fontWeight(.semibold)
                            
                            ForEach(product.allergens, id:\.self){
                                Text($0.name)
                            }
                        }
                        Spacer()
                        VStack(alignment: .leading){
                            Text("Zusatzstoffe")
                                .fontWeight(.semibold)
                            
                            ForEach(product.additives, id:\.self){
                                Text($0.name)
                            }
                        }
                    }
                } label: {
                    Text("Allergene & Zusatzstoffe ")
                }
                
            }.padding(.horizontal)
            
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                ProductVisibilityButton(isSet: product.isVisible, product: product)

            }
        }
    }
    
}

struct MenuDetail_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetail(product: Product.dummyProducts[0])
    }
}

