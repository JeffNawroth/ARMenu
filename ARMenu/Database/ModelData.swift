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

class ModelData: ObservableObject{
    @Published var offers = [Offer]()
    @Published var products = [Product]()
    @Published var allergens = [Allergen]()
    @Published var additives = [Additive]()
    @Published var categories = [Category]()
    @Published var toppings = [Topping]()
    @Published var errorMessage: String?
    
    //Test
    var db = Firestore.firestore()
    let storage = Storage.storage()
    
    
    func fetchProductsData() {
        db.collection("ImHörnken").document("Menu").collection("Products").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.products = documents.compactMap { queryDocumentSnapshot -> Product? in
                
                return try? queryDocumentSnapshot.data(as: Product.self)
                
            }
            
        }
    }
    
    func fetchToppingsData() {
        db.collection("ImHörnken").document("Menu").collection("Toppings").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.toppings = documents.compactMap { queryDocumentSnapshot -> Topping? in
                
                return try? queryDocumentSnapshot.data(as: Topping.self)
                
            }
            
        }
    }
    
    func fetchAllergensData() {
        db.collection("ImHörnken").document("Menu").collection("Allergens").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.allergens = documents.compactMap { queryDocumentSnapshot -> Allergen? in
                
                return try? queryDocumentSnapshot.data(as: Allergen.self)
                
            }
            
        }
    }
    
    func fetchAdditivesData() {
        db.collection("ImHörnken").document("Menu").collection("Additives").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.additives = documents.compactMap { queryDocumentSnapshot -> Additive? in
                
                return try? queryDocumentSnapshot.data(as: Additive.self)
                
            }
            
        }
    }
    
    func fetchCategoriesData() {
        db.collection("ImHörnken").document("Menu").collection("Categories").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.categories = documents.compactMap { queryDocumentSnapshot -> Category? in
                
                return try? queryDocumentSnapshot.data(as: Category.self)
                
            }
            
        }
    }
    
    func addProductController(productToAdd: Product, imageToAdd: UIImage)    {
        uploadImage(image: imageToAdd, productToAdd: productToAdd)
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
    
    func uploadImage(image:UIImage, productToAdd:Product) {
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storage.reference().child(productToAdd.name).putData(imageData, metadata: metadata){
                (_, err) in
                if let err = err {
                    print("an error has occurred - \(err.localizedDescription)")
                } else {
                    print("image uploaded successfully")
                    self.getImagePath(productToAdd: productToAdd)
                    
                }
            }
        } else {
            print("couldn't unwrap/case image to data")
        }
    }
    
    
    func getImagePath(productToAdd: Product){
        print("Ich war hier")
        let storageRef = Storage.storage().reference(withPath: productToAdd.name)
        
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Fehler")
                return
            }
            let imageURL = url.absoluteString
            addProduct(productToAdd: productToAdd, imagePath: imageURL)
        }
        )
        
    }
    
    func addProduct(productToAdd: Product, imagePath: String){
        
        let product = Product(image: imagePath, name: productToAdd.name, category: productToAdd.category, price: productToAdd.price,description: productToAdd.description, isVegan: productToAdd.isVegan, isBio: productToAdd.isBio, isFairtrade: productToAdd.isFairtrade, nutritionFacts: productToAdd.nutritionFacts, allergens: productToAdd.allergens, additives: productToAdd.additives, toppings: productToAdd.toppings)
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Products")
        do {
            let newDocReference = try collectionRef.addDocument(from: product)
            print("Product stored with new document reference: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error")
        }
    }
    
    
    
    
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
    
    func deleteAllergen(allergenToDelete: Allergen){
        //Get a reference to the database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection("ImHörnken").document("Menu").collection("Allergens").document(allergenToDelete.id ?? "").delete { error in
            //Check for Errors
            if error == nil{
                //No errors
                
                //Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    //Remove the product that wass just deleted
                    self.allergens.removeAll { i in
                        // Check for product to remove
                        return i.id == allergenToDelete.id
                    }
                }
                
            }
        }
        
    }
    
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
    
    func deleteAdditive(additiveToDelete: Additive){
        //Get a reference to the database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection("ImHörnken").document("Menu").collection("Additives").document(additiveToDelete.id ?? "").delete { error in
            //Check for Errors
            if error == nil{
                //No errors
                
                //Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    //Remove the product that wass just deleted
                    self.additives.removeAll { i in
                        // Check for product to remove
                        return i.id == additiveToDelete.id
                    }
                }
                
            }
        }
        
    }
    
    
    func addTopping(toppingToAdd: Topping) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Toppings")
        do {
            let newDocReference = try collectionRef.addDocument(from: toppingToAdd)
            print("Offer stored with new document reference: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error")
        }
    }
    
    
    func deleteTopping(toppingToDelete: Topping){
        //Get a reference to the database
        let db = Firestore.firestore()
        //Specify the document to delete
        db.collection("ImHörnken").document("Menu").collection("Toppings").document(toppingToDelete.id ?? "").delete { error in
            //Check for Errors
            if error == nil{
                //No errors
                
                //Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    //Remove the product that wass just deleted
                    self.toppings.removeAll { i in
                        // Check for product to remove
                        return i.id == toppingToDelete.id
                    }
                }
                
            }
        }
        
    }
    
}

