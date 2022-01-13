//
//  ProductsViewModel.swift
//  ARMenu
//
//  Created by Eren Cicek on 12.01.22.
//
import SwiftUI
import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore


class ProductsViewModel: ObservableObject{
    @Published var products = [Product]()
    @Published var errorMessage: String?
    var db = Firestore.firestore()
    
    
    

    
//    func getData(){
//
//        let db = Firestore.firestore()
//
//        db.collection("ImHörnken").document("Winterspeisekarte").collection("Products").addSnapshotListener { snap, err in
//
//            if err != nil{
//
//                print((err?.localizedDescription)!)
//                return
//            }
//
//            for i in snap!.documentChanges{
//
//
//                let id = i.document.documentID
//                let name = i.document.get("name") as? String ?? ""
//                let category = i.document.get("category") as? String ?? ""
//                let price = i.document.get("price") as? Double ?? 0
//                let description = i.document.get("description") as? String ?? ""
//                let image = i.document.get("image") as? String ?? ""
//                let isVegan = i.document.get("isVegan") as? Bool ?? false
//                let isBio = i.document.get("isBio") as? Bool ?? false
//                let isFairtrade = i.document.get("isFairtrade") as? Bool ?? false
//                let nutritionFacts = i.document.get("nutritionFacts") as? Double ?? 0
//                let allergens = i.document.get("allergens") as? [String] ?? [""]
//                let allergens2 = allergens.map { allergen in
//                    Allergen(name: allergen)
//                }
//                let additives = i.document.get("additives") as? [String] ?? [""]
//
//                self.products.append(Product(id: id, image: image, name: name, category: category, price: price, description: description, isVegan: isVegan, isBio: isBio, isFairtrade: isFairtrade, nutritionFacts: nutritionFacts, allergens: allergens2, additives: additives))
//            }
//        }
//    }
    func addData(name: String, image: String, price: Double, description: String, isVegan: Bool, isBio: Bool, isFairtrade: Bool, category: String, nutritionFacts: [Double], allergens: [String], additives: [String]){
            // get a reference to the database
            let db = Firestore.firestore()
    
            // add a document to the database
        db.collection("ImHörnken").document("WinterSpeisekarte").collection("Products").addDocument(data: ["name": name,"image": image, "price": price, "description": description, "isVegan": isVegan, "isBio": isBio, "isFairtrade": isFairtrade, "category": category, "nutritionFacts": nutritionFacts, "allergens": allergens, "additives": additives]) { error in
    
                // Check for errors
                if error == nil{
                    //No errors
                    // Call getData() to retrieve latest Data
//                    self.fetchData()
                }
                else{
                    //Handle the error
                }
            }
        }
    
//    func fetchData(){
//
//        db.collection("ImHörnken").document("WinterSpeisekarte").collection("Products").addSnapshotListener { querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//
//                print("No documents")
//                return
//            }
//
//            self.products = documents.map({ queryDocumentSnapshot -> Product in
//
//                let data = queryDocumentSnapshot.data()
//
//                let name = data["name"] as? String ?? ""
//                let price = data["price"] as? Double ?? 0
//                let image = data["image"] as? String ?? ""
//                let description = data["description"] as? String ?? ""
//                let isBio = data["isBio"] as? Bool ?? false
//                let isVegan = data["isVegan"] as? Bool ?? false
//                let isFairtrade = data["isFairtrade"] as? Bool ?? false
//                let category = data["category"] as? String ?? ""
//                let nutritionFacts = data["nutritionFacts"] as? [[String: Any]]
//                let calories = nutritionFacts!["calories"] as? Int
////                let carbs = nutritionFacts!["carbs"] as? String
////                let fat = nutritionFacts!["fat"] as? Double
////                let protein = nutritionFacts!["protein"] as? Double
////                let nutritionFacts2 = NutritionFacts(calories: calories, fat: fat, carbs: carbs, protein: protein)
//
//                let allergens = data["allergens"] as? [String] ?? []
//                let allergens2 = allergens.map { allergen in
//                    Allergen(name: allergen)
//                }
//                let additives = data["additives"] as? [String] ?? []
//                let additives2 = additives.map { additive in
//                    Additive(name: additive)
//                }
//                print(calories)
//
//                return Product(id: queryDocumentSnapshot.documentID,image: image, name: name, category: category, price: price, description: description, isVegan: isVegan, isBio: isBio, isFairtrade: isFairtrade, nutritionFacts: NutritionFacts(calories: 0, fat: 0, carbs: 0, protein: 0), allergens: allergens2, additives: additives2)
//
//            })
//
//        }
//    }
//    func fetchData(documentId: String) {
//        let docRef = db.collection("ImHörnken").document("WinterSpeisekarte").collection("Products").document(documentId)
//      docRef.getDocument { document, error in
//        if let error = error as NSError? {
//          self.errorMessage = "Error getting document: \(error.localizedDescription)"
//        }
//        else {
//          if let document = document {
//            do {
//                self.products.append(try document.data(as: Product.self)!)
//            }
//            catch {
//              print(error)
//            }
//          }
//        }
//      }
//    }
    func fetchData() {
        db.collection("ImHörnken").document("WinterSpeisekarte").collection("Products").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
          
        self.products = documents.compactMap { queryDocumentSnapshot -> Product? in
        
          return try? queryDocumentSnapshot.data(as: Product.self)
        
        }
            
      }
    }
    
    func deleteData(productToDelete: Product){
            //Get a reference to the database
            let db = Firestore.firestore()
            //Specify the document to delete
        db.collection("ImHörnken").document("WinterSpeisekarte").collection("Products").document(productToDelete.id ?? "").delete { error in
                //Check for Errors
                if error == nil{
                    //No errors

                    //Update the UI from the main thread
                    DispatchQueue.main.async {

                    //Remove the product that wass just deleted
                        self.products.removeAll { i in
                            // Check for product to remove
                            return i.id == productToDelete.id
                        }
                    }

                }
            }

        }
    
    func updateData(productToUpdate: Product){

        //Get a reference to the database
        let db = Firestore.firestore()

        //Set the data to update
        db.collection("ImHörnken").document("WinterSpeisekarte").collection("Products").document(productToUpdate.id ?? "").setData(["name":"Updated: \(productToUpdate.name)"] , merge: true) { error in

            //Check for Errors
            if error == nil{

                //Get the new data
//                self.fetchData()
            }
        }
    }
    
    }
    
    

