import Foundation
import SwiftUI
import Firebase
import SDWebImageSwiftUI
import FirebaseFirestoreSwift
import RealityKit




struct ProductView : View{
    
    var product: Product
    
    
    
    var body: some View{
        
        VStack{
            VStack{
            Text(product.name)
            Text(product.category)
            Text(String(product.price))
            Text(product.description)
            }
            VStack{
            Text(String((product.isVegan)))
            Text(String((product.isBio)))
            Text(String((product.isFairtrade)))
            }
            VStack{
            Text(String(product.nutritionFacts.calories))
            Text(String(product.nutritionFacts.fat))
            Text(String(product.nutritionFacts.protein))
            Text(String(product.nutritionFacts.carbs))
            }
            VStack{
                ForEach(product.allergens, id: \.self){ allergen in
                    Text(allergen)
                }
                ForEach(product.additives, id: \.self){ additive in
                    Text(additive)
                }
                
            }
            
            
        }

    }
    
}


