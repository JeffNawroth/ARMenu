//
//  getProductData.swift
//  ARMenu
//
//  Created by Eren Cicek on 05.01.22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore

class getProductData: ObservableObject{
    
    @Published var data = [Product]()
    var db = Firestore.firestore()
    
    init(){
        
        let db = Firestore.firestore()
        
        db.collection("Products").addSnapshotListener { snap, err in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
                let id = i.document.documentID
                let name = i.document.get("name") as? String ?? ""
                let price = i.document.get("price") as? Double ?? 0
                let description = i.document.get("description") as? String ?? ""
                let image = i.document.get("image") as? String ?? ""
                let isVegan = i.document.get("isVegan") as? Bool ?? false
                let isBio = i.document.get("isBio") as? Bool ?? false
                let isFairtrade = i.document.get("isFairtrade") as? Bool ?? false
                
                self.data.append(Product(id: id, image: image, name: name, category: Category(id: id, name: name), price: price, description: description, isVegan: isVegan, isBio: isBio, isFairtrade: isFairtrade))
            }
        }
    }
    func updateData(productToUpdate: Product){
    
            //Get a reference to the database
            let db = Firestore.firestore()
    
            //Set the data to update
            db.collection("Products").document(productToUpdate.id).setData(["name":"Updated: \(productToUpdate.name)"] , merge: true) { error in
    
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
            db.collection("Products").document(productToDelete.id).delete { error in
                //Check for Errors
                if error == nil{
                    //No errors
    
                    //Update the UI from the main thread
                    DispatchQueue.main.async {
    
                    //Remove the product that wass just deleted
                        self.data.removeAll { i in
                            // Check for product to remove
                            return i.id == productToDelete.id
                        }
                    }
    
                }
            }
    
        }
    func getData(){
        
        let db = Firestore.firestore()
        
        db.collection("Products").addSnapshotListener { snap, err in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                
                let id = i.document.documentID
                let name = i.document.get("name") as? String ?? ""
                let price = i.document.get("price") as? Double ?? 0
                let description = i.document.get("description") as? String ?? ""
                let image = i.document.get("image") as? String ?? ""
                let isVegan = i.document.get("isVegan") as? Bool ?? false
                let isBio = i.document.get("isBio") as? Bool ?? false
                let isFairtrade = i.document.get("isFairtrade") as? Bool ?? false
                
                self.data.append(Product(id: id, image: image, name: name, category: Category.init(name: name), price: price, description: description, isVegan: isVegan, isBio: isBio, isFairtrade: isFairtrade))
            }
        }
    }
    func addData(name: String, image: String, price: Double, description: String, isVegan: Bool, isBio: Bool, isFairtrade: Bool){
            // get a reference to the database
            let db = Firestore.firestore()
    
            // add a document to the database
        db.collection("Products").addDocument(data: ["name": name,"image": image, "price": price, "description": description, "isVegan": isVegan, "isBio": isBio, "isFairtrade": isFairtrade]) { error in
    
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
    
    //
    //    func addData(name: String, category: String, price: Double, description: String, isVegan: Bool, isBio: Bool, isFairtrade: Bool){
    //        // get a reference to the database
    //        let db = Firestore.firestore()
    //
    //        // add a document to the database
    //        db.collection("Product").addDocument(data: ["name": name, "category": category, "price": price, "description": description, "isVegan": isVegan, "isBio": isBio, "isFairtrade": isFairtrade]) { error in
    //
    //            // Check for errors
    //            if error == nil{
    //                //No errors
    //                // Call getData() to retrieve latest Data
    //                self.getData()
    //            }
    //            else{
    //                //Handle the error
    //            }
    //        }
    //    }
    //    func getData(){
    //
    //        // reference to the database
    //        let db = Firestore.firestore()
    //
    //        //read the documents of a specific path, here it's "Product"
    //        db.collection("Product").getDocuments { snapshot, error in
    //
    //            if error == nil{
    //                //no errors
    //                if let snapshot = snapshot {
    //
    //                    //Update to the main thread
    //                    DispatchQueue.main.async {
    //
    //                        //Get all the documents
    ////                        self.products = snapshot.documents.map { d in
    ////
    ////                            //Create a Product item for each document returned
    ////                            return Product(id: d.documentID,
    ////                                           name: d["name"] as? String ?? "",
    //////                                           category: d["category"] as? String ?? "",
    ////                                           price: d["price"] as? Double ?? 0,
    ////                                           description: d["description"] as? String ?? "",
    ////                                           isVegan: d["isVegan"] as? Bool ?? false,
    ////                                           isBio: d["isBio"] as? Bool ?? false,
    ////                                           isFairtrade: d["isFairtrade"] as? Bool ?? false)
    //////                                           nutritionFacts: d["nutritionFacts"] as? NutritionFacts ?? NutritionFacts(calories: 0, fat: 0, carbs: 0, protein: 0))
    ////
    ////                        }
    //                    }
    //
    //                }
    //            }
    //            else{
    //                //handle the error
    //            }
    //        }
    //
    //    }
}