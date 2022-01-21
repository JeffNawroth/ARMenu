//
//  ProductsViewModel.swift
//  ARMenu
//
//  Created by Eren Cicek on 12.01.22.
//
import SwiftUI
import Foundation
import Firebase
import FirebaseStorage

class ProductsViewModel: ObservableObject{
    @Published var offers = [Offer]()
    @Published var products = [Product]()
    @Published var allergens = [String]()
    @Published var additives = [String]()
    @Published var categories = [String]()
    @Published var errorMessage: String?
    @Published var inputImage: UIImage?
    var imageURL = URL(string: "")
    
    var db = Firestore.firestore()
    let storage = Storage.storage()
    
    
    func fetchProductsData() {
        db.collection("ImHörnken").document("Menu").collection("Tests").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
          
        self.products = documents.compactMap { queryDocumentSnapshot -> Product? in
        
          return try? queryDocumentSnapshot.data(as: Product.self)
        
        }
            
      }
    }
    
    func addProductController(productToAdd: Product, imageToAdd: UIImage) {
        uploadImage(image: imageToAdd, imageName: productToAdd.name)
        print("Upload abgeschlossen")
        getImagePath(imageName: productToAdd.name, productToAdd: productToAdd)
    }
    
    func uploadImage(image:UIImage, imageName: String){
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            let metadata = StorageMetadata()
                   metadata.contentType = "image/jpeg"
            storage.reference().child(imageName).putData(imageData, metadata: metadata){
                (_, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    print("image uploaded successfully")
                }
            }
        } else {
            print("couldn't unwrap/case image to data")
        }
    }
    
    func addProduct(productToAdd: Product, imagePath: String){
        print(imagePath)
        print("Kurz vor Produkterstellung")
        let product = Product(image: imagePath, name: productToAdd.name, price: productToAdd.price, description: productToAdd.description, isVegan: productToAdd.isVegan, isBio: productToAdd.isBio, isFairtrade: productToAdd.isFairtrade, nutritionFacts: productToAdd.nutritionFacts)
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Tests")
      do {
        let newDocReference = try collectionRef.addDocument(from: product)
        print("Product stored with new document reference: \(newDocReference)")
      }
      catch {
        print(error)
          print("Error")
      }
    }
    
    func getImagePath(imageName: String, productToAdd: Product){
             let storageRef = Storage.storage().reference(withPath: imageName)
        print(imageName)
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Fehler")
                return
            }
            let imageURL = url.absoluteString
            print(imageURL)
            print("vor Methodenaufruf")
            addProduct(productToAdd: productToAdd, imagePath: imageURL)
        }
        )
        
}
    func deleteProduct(productToDelete: Product){
            //Get a reference to the database
            let db = Firestore.firestore()
            //Specify the document to delete
        db.collection("ImHörnken").document("Menu").collection("Products").document(productToDelete.id ?? "").delete { error in
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
    
    func fetchOffersData() {
        db.collection("ImHörnken").document("Menu").collection("Offers").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
          
        self.offers = documents.compactMap { queryDocumentSnapshot -> Offer? in
        
          return try? queryDocumentSnapshot.data(as: Offer.self)
        
        }
            
      }
    }
    
    func addOffer(offerToAdd: Offer) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Offers")
      do {
        let newDocReference = try collectionRef.addDocument(from: offerToAdd)
        print("Offer stored with new document reference: \(newDocReference)")
      }
      catch {
        print(error)
          print("Error")
      }
    }
    
    func deleteOffer(offerToDelete: Offer){
            //Get a reference to the database
            let db = Firestore.firestore()
            //Specify the document to delete
        db.collection("ImHörnken").document("Menu").collection("Offers").document(offerToDelete.id ?? "").delete { error in
                //Check for Errors
                if error == nil{
                    //No errors

                    //Update the UI from the main thread
                    DispatchQueue.main.async {

                    //Remove the product that wass just deleted
                        self.offers.removeAll { i in
                            // Check for product to remove
                            return i.id == offerToDelete.id
                        }
                    }

                }
            }

        }
    
    func addCategory(categoryToAdd: Category) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Categories")
      do {
        let newDocReference = try collectionRef.addDocument(from: categoryToAdd)
        print("Offer stored with new document reference: \(newDocReference)")
      }
      catch {
        print(error)
          print("Error")
      }
    }
    
//    func deleteCategory(categoryToDelete: Category){
//            //Get a reference to the database
//            let db = Firestore.firestore()
//            //Specify the document to delete
//        db.collection("ImHörnken").document("Menu").collection("Categories").document(categoryToDelete.id ?? "").delete { error in
//                //Check for Errors
//                if error == nil{
//                    //No errors
//
//                    //Update the UI from the main thread
//                    DispatchQueue.main.async {
//
//                    //Remove the product that wass just deleted
//                        self.categories.removeAll { i in
//                            // Check for product to remove
//                            return i.id == categoryToDelete.id
//                        }
//                    }
//
//                }
//            }
//
//        }
    
    func addAdditive(additiveToAdd: Additive) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Additives")
      do {
        let newDocReference = try collectionRef.addDocument(from: additiveToAdd)
        print("Offer stored with new document reference: \(newDocReference)")
      }
      catch {
        print(error)
          print("Error")
      }
    }
    
//    func deleteAdditive(additiveToDelete: Additive){
//            //Get a reference to the database
//            let db = Firestore.firestore()
//            //Specify the document to delete
//        db.collection("ImHörnken").document("Menu").collection("Additives").document(additiveToDelete.id ?? "").delete { error in
//                //Check for Errors
//                if error == nil{
//                    //No errors
//
//                    //Update the UI from the main thread
//                    DispatchQueue.main.async {
//
//                    //Remove the product that wass just deleted
//                        self.additives.removeAll { i in
//                            // Check for product to remove
//                            return i.id == additiveToDelete.id
//                        }
//                    }
//
//                }
//            }
//
//        }
    
    func addAllergen(allergenToAdd: Allergen) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Allergens")
      do {
        let newDocReference = try collectionRef.addDocument(from: allergenToAdd)
        print("Offer stored with new document reference: \(newDocReference)")
      }
      catch {
        print(error)
          print("Error")
      }
    }
    
//    func deleteAllergen(allergenToDelete: Allergen){
//            //Get a reference to the database
//            let db = Firestore.firestore()
//            //Specify the document to delete
//        db.collection("ImHörnken").document("Menu").collection("Allergens").document(allergenToDelete.id ?? "").delete { error in
//                //Check for Errors
//                if error == nil{
//                    //No errors
//
//                    //Update the UI from the main thread
//                    DispatchQueue.main.async {
//
//                    //Remove the product that wass just deleted
//                        self.allergens.removeAll { i in
//                            // Check for product to remove
//                            return i.id == allergenToDelete.id
//                        }
//                    }
//
//                }
//            }
//
//        }
//
    func updateData(productToUpdate: Product){

        //Get a reference to the database
        let db = Firestore.firestore()

        //Set the data to update
        db.collection("ImHörnken").document("Menu").collection("Products").document(productToUpdate.id ?? "").setData(["name":"Updated: \(productToUpdate.name)"] , merge: true) { error in

            //Check for Errors
            if error == nil{

                //Get the new data
                self.fetchProductsData()
            }
        }
    }
    
//    func addTopping(toppingToAdd: Topping) {
//        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Toppings")
//      do {
//        let newDocReference = try collectionRef.addDocument(from: toppingToAdd)
//        print("Offer stored with new document reference: \(newDocReference)")
//      }
//      catch {
//        print(error)
//          print("Error")
//      }
//    }
//
//    func deleteTopping(toppingToDelete: Topping){
//            //Get a reference to the database
//            let db = Firestore.firestore()
//            //Specify the document to delete
//        db.collection("ImHörnken").document("Menu").collection("Toppings").document(toppingToDelete.id ?? "").delete { error in
//                //Check for Errors
//                if error == nil{
//                    //No errors
//
//                    //Update the UI from the main thread
//                    DispatchQueue.main.async {
//
//                    //Remove the product that wass just deleted
//                        self.toppings.removeAll { i in
//                            // Check for product to remove
//                            return i.id == toppingToDelete.id
//                        }
//                    }
//
//                }
//            }
//
//        }
//    func fetchToppingsData() {
//        db.collection("ImHörnken").document("Menu").collection("Toppings").addSnapshotListener { (querySnapshot, error) in
//        guard let documents = querySnapshot?.documents else {
//          print("No documents")
//          return
//        }
//
//        self.offers = documents.compactMap { queryDocumentSnapshot -> Topping? in
//
//          return try? queryDocumentSnapshot.data(as: Topping.self)
//
//        }
//
//      }
//    }
    
//    func addToAllergens(allergenToAdd: String) {
//
//        let db = db.collection("ImHörnken").document("Menu").collection("Allergens").document("FCugrQpBJyXia0Lj1KSg")
//
//            db.updateData([
//    "allergens": FieldValue.arrayUnion([allergenToAdd])
//            ])
//
//    }
//
//    func deleteFromAllergens(allergenToDelete: String){
//
//        let db = db.collection("ImHörnken").document("Menu").collection("Allergens").document("FCugrQpBJyXia0Lj1KSg")
//
//            db.updateData([
//    "allergens": FieldValue.arrayRemove([allergenToDelete])
//            ])
//    }
//
//    func addToAdditives(additiveToAdd: String) {
//
//        let db = db.collection("ImHörnken").document("Menu").collection("Additives").document("lfPjJLrOZeHJHzuqygl4")
//
//            db.updateData([
//    "additives": FieldValue.arrayUnion([additiveToAdd])
//            ])
//    }
//
//    func deleteFromAdditives(allergenToDelete: String){
//
//        let db = db.collection("ImHörnken").document("Menu").collection("Additives").document("lfPjJLrOZeHJHzuqygl4")
//
//            db.updateData([
//    "additives": FieldValue.arrayRemove([allergenToDelete])
//            ])
//    }
//
//    func addToCategories(categoryToAdd: String) {
//
//        let db = db.collection("ImHörnken").document("Menu").collection("Additives").document("q36Y2TFvgKE2zrOH8oFX")
//
//            db.updateData([
//    "categories": FieldValue.arrayUnion([categoryToAdd])
//            ])
//    }
//
//    func deleteFromCategories(categoryToDelete: String){
//
//        let db = db.collection("ImHörnken").document("Menu").collection("Categories").document("q36Y2TFvgKE2zrOH8oFX")
//
//            db.updateData([
//    "categories": FieldValue.arrayRemove([categoryToDelete])
//            ])
//    }
//
//
//    func fetchAdditivesData() {
//        db.collection("ImHörnken").document("Menu").collection("Additives").addSnapshotListener { (querySnapshot, error) in
//        guard let documents = querySnapshot?.documents else {
//          print("No documents")
//          return
//        }
//
//        self.additives = documents.compactMap { queryDocumentSnapshot -> Additive? in
//
//          return try? queryDocumentSnapshot.data(as: Additive.self)
//
//        }
//
//      }
//    }
//
//    func fetchCategoriesData() {
//        db.collection("ImHörnken").document("Menu").collection("Categories").addSnapshotListener { (querySnapshot, error) in
//        guard let documents = querySnapshot?.documents else {
//          print("No documents")
//          return
//        }
//
//        self.categories = documents.compactMap { queryDocumentSnapshot -> Category? in
//
//          return try? queryDocumentSnapshot.data(as: Category.self)
//
//        }
//
//      }
//    }
    
    
    
}

