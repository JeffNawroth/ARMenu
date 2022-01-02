//
//  ProductViewModel.swift
//  ARMenu
//
//  Created by Eren Cicek on 02.01.22.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class ProductsViewModel: ObservableObject {
    @Published var products = [Product]()
    
    func updateData(productToUpdate: Product){
        
        //Get a reference to the database
        let db = Firestore.firestore()
        
        //Set the data to update
        db.collection("Product").document(productToUpdate.id).setData(["name":"Updated: \(productToUpdate.name)"] , merge: true) { error in
            
            //Check for Errors
            if error == nil{
                
                //Get the new data
                self.getData()
            }
        }
    }
    
    func deleteData(productToDelete: Product){
        //Get a reference to the database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection("Product").document(productToDelete.id).delete { error in
            //Check for Errors
            if error == nil{
                //No errors
                
                //Update the UI from the main thread
                DispatchQueue.main.async {
                    
                //Remove the product that wass just deleted
                    self.products.removeAll { product in
                        // Check for product to remove
                        return product.id == productToDelete.id
                    }
                }
                
            }
        }
            
    }
    
    func addData(name: String, category: String, price: Double, description: String, isVegan: Bool, isBio: Bool, isFairtrade: Bool){
        // get a reference to the database
        let db = Firestore.firestore()
        
        // add a document to the database
        db.collection("Product").addDocument(data: ["name": name, "category": category, "price": price, "description": description, "isVegan": isVegan, "isBio": isBio, "isFairtrade": isFairtrade]) { error in
            
            // Check for errors
            if error == nil{
                //No errors
                // Call getData() to retrieve latest Data
                self.getData()
            }
            else{
                //Handle the error
            }
        }
    }
    func getData(){
        
        // reference to the database
        let db = Firestore.firestore()
        
        //read the documents of a specific path, here it's "Product"
        db.collection("Product").getDocuments { snapshot, error in
            
            if error == nil{
                //no errors
                if let snapshot = snapshot {
                    
                    //Update to the main thread
                    DispatchQueue.main.async {
                        
                        //Get all the documents
                        self.products = snapshot.documents.map { d in
                            
                            //Create a Product item for each document returned
                            return Product(id: d.documentID,
                                           name: d["name"] as? String ?? "",
                                           category: d["category"] as? String ?? "",
                                           price: d["price"] as? Double ?? 0,
                                           description: d["description"] as? String ?? "",
                                           isVegan: d["isVegan"] as? Bool ?? false,
                                           isBio: d["isBio"] as? Bool ?? false,
                                           isFairtrade: d["isFairtrade"] as? Bool ?? false, nutritionFacts: d["nutritionFacts"] as? NutritionFacts ?? NutritionFacts(calories: 0, fat: 0, carbs: 0, protein: 0))
                            
                        }
                    }
                    
                }
            }
            else{
                //handle the error
            }
        }
        
    }
}

