//
//  MenuDetail.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct MenuDetail: View {
    
    var product: Product
    @State private var showingARPreview = false
    @State private var nutritionsExpanded = false
    @State private var allergensExpanded = false

    
    var body: some View {
        ScrollView{
            product.image
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
            }.padding(.horizontal)
            
            DisclosureGroup(isExpanded: $allergensExpanded) {
                
                HStack(alignment: .top){

                    VStack(alignment: .leading){
                        Text("Allergene")
                            .fontWeight(.semibold)

                            ForEach(product.allergens){allergen in
                                Text(allergen.name)
                            }
                    }
                    Spacer()
                    VStack(alignment: .leading){
                        Text("Zusatzstoffe")
                            .fontWeight(.semibold)

                        ForEach(product.additives){additive in
                            Text(additive.name)
                        }
                    }
                    Spacer()
                }
            } label: {
                Text("Allergene & Zusatzstoffe ")
            }.padding(.horizontal)
            
            
            
            
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct MenuDetail_Previews: PreviewProvider {
    static var previews: some View {
        MenuDetail(product: ModelData().products[0])
    }
}

