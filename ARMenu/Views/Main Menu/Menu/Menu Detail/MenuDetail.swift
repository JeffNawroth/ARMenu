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
    @State private var showingSheet = false
    var body: some View {
        ScrollView{
            if let image = product.image{
                AnimatedImage(url: URL(string: image))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding()
            }
            else{
               Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .shadow(radius: 3)
                    .padding()
            }
            
            VStack(alignment: .leading){
                
                HStack{
                    VStack(alignment: .leading){
                        if let category = product.category{
                            Text(category.name)
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                        }
                        
                        
                        HStack{
                            Text(product.name!)
                                .font(.title)
                            
                            Spacer()
                            
                            if let price = product.price{
                                Text("\(price, specifier: "%.2f")")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                                Text("•")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                          
                            
                            if let servingSize = product.servingSize{
                                Text("\(servingSize.size)" + servingSize.unit.name)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                    }
                    
                }
                
                Spacer()
                
                if (product.isVegan != nil || product.isBio != nil || product.isFairtrade != nil){
                    HStack{
                        if let isVegan = product.isVegan{
                            if isVegan{
                                Image("vegan")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                            }
                        }
                        
                        
                        if let isBio = product.isBio{
                            if isBio{
                                Image("bio")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                            }
                        }
                        
                        if let isFairtrade = product.isFairtrade{
                            if isFairtrade{
                                Image("fairtrade")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                            }
                        }
                       
                    }
                }
           
                
                
                
                Divider()
                
                if product.model != nil{
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
                
                ZStack{
                    ARViewContainer(product: product)
                        .ignoresSafeArea()
                    VStack{
                        HStack{
                            Spacer()
                            Button {
                                showingARPreview = false
                            } label: {
                                Image(systemName: "xmark")
                                    .imageScale(.large)
                            }
                            .padding()
                        }
                        Spacer()
                    }



                }
            }
                }
             
                if let description = product.description{
                    Text("Beschreibung")
                        .font(.title2)
                    Text(description)
                }
            }
            .padding()
            
            VStack{
                
                if let toppings = product.toppings{
                    DisclosureGroup(isExpanded: $toppingsExpanded) {
                        ForEach(toppings, id: \.self){topping in
                            HStack{
                                Text(topping.name)
                                Spacer()
                                Text("+ \(topping.price, specifier: "%.2f")")
                            }
                        }
                    } label: {
                        Text("Toppings")
                    }

                }
                
                
                
                if let nutritionFacts =  product.nutritionFacts{
                    DisclosureGroup(isExpanded: $nutritionsExpanded) {
                        HStack{
                            Spacer()
                            Text("pro 100 g")
                                .fontWeight(.semibold)
                            
                        }
                       
                        if let calories = nutritionFacts.calories{
                            HStack{
                                Text("Brennwert")
                                Spacer()
                                Text(String(calories) + " kcal")
                                
                            }
                        }
                        
                        if let fat = nutritionFacts.fat{
                            HStack{
                                Text("Fett")
                                Spacer()
                                Text(String(fat) + " g")
                            }
                        }
                        
                        if let carbs = nutritionFacts.carbs{
                            HStack{
                                Text("Kohlenhydrate")
                                Spacer()
                                Text(String(carbs) + " g")
                            }
                        }
                        
                        if let protein = nutritionFacts.protein{
                            HStack{
                                Text("Protein")
                                Spacer()
                                Text(String(protein) + " g")
                            }
                        }
                      
                        
                    } label: {
                        Text("Nährwerte")
                    }
                }
               
                
                
                if product.allergens != nil || product.additives != nil{
                    DisclosureGroup(isExpanded: $allergensExpanded) {
                        
                        HStack(alignment: .top){
                            if let allergens = product.allergens{
                                VStack(alignment: .leading){
                                    if product.additives != nil{
                                        Text("Allergene")
                                            .fontWeight(.semibold)
                                    }
                                    ForEach(allergens, id:\.self){
                                        Text($0.name)
                                    }
                                }
                                Spacer()
                            }
                            
                            if let additives = product.additives{
                                VStack(alignment: .leading){
                                    if product.allergens != nil{
                                        Text("Zusatzstoffe")
                                            .fontWeight(.semibold)
                                    }
                                    ForEach(additives, id:\.self){
                                        Text($0.name)
                                    }
                                }
                                if product.allergens == nil{
                                    Spacer()
                                }
                            }
                           
                        }
                    } label: {
                        if product.additives != nil && product.allergens != nil{
                            Text("Allergene & Zusatzstoffe")
                        }
                        else if product.additives != nil{
                            Text("Zusatzstoffe")
                        }
                        else if product.allergens != nil{
                            Text("Allergene")
                        }
                            
                    }
                }
                
                
            }.padding(.horizontal)
            
        }
        .navigationTitle(product.name!)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingSheet = true
                } label: {
                    Image(systemName: "square.and.pencil")
                }
                .sheet(isPresented: $showingSheet) {
                    EditProduct(product: product, showingSheet: $showingSheet)
                }
                
            }
        }
    }
    
}

struct MenuDetail_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetail(product: Product.dummyProduct)
    }
}

