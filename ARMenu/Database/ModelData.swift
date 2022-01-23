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
    
    var db = Firestore.firestore()

    //MARK: Product
    
    func fetchProductsData() {
        db.collection("ImHörnken").document("Menu").collection("Products").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Produkte gefunden!")
                return
            }
            
            self.products = documents.compactMap { queryDocumentSnapshot -> Product? in
                return try? queryDocumentSnapshot.data(as: Product.self)
            }
            
        }
    }
    
    func addProduct(productToAdd: Product, imagePath: String){
        
        let product = Product(image: imagePath, name: productToAdd.name, category: productToAdd.category, price: productToAdd.price,description: productToAdd.description, isVegan: productToAdd.isVegan, isBio: productToAdd.isBio, isFairtrade: productToAdd.isFairtrade, isVisible: productToAdd.isVisible, nutritionFacts: productToAdd.nutritionFacts, allergens: productToAdd.allergens, additives: productToAdd.additives, toppings: productToAdd.toppings)
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Products")
        do {
            let newDocReference = try collectionRef.addDocument(from: product)
            print("Produkt hinzugefügt mit folgender Referenz: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Produkt konnte nicht hinzugefügt werden!")
        }
    }
    
    func addProductController(productToAdd: Product, imageToAdd: UIImage)    {
        uploadImage(image: imageToAdd, productToAdd: productToAdd)
        }
        
    func deleteProduct(productToDelete: Product){
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
                print("Produkt wurde erfolgreich gelöscht!")
            }
            else{
                print("Error: Produkt konnte nicht gelöscht werden!")
            }
        }
        let storage = Storage.storage()
        storage.reference().child(productToDelete.name).delete { error in
            if error != nil {
              print("Error: Bild konnte nicht gelöscht werden!")
            } else {
              print("Bild wurde erfolgreich gelöscht!")
            }
          }
        
    }
    
    //Image zum Produkt hinzufügen
    
    func uploadImage(image:UIImage, productToAdd:Product) {
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storage.reference().child(productToAdd.name).putData(imageData, metadata: metadata){
                (_, err) in
                if let err = err {
                    print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                } else {
                    print("Bild wurde erfolgreich hochgeladen!")
                    self.getImagePath(productToAdd: productToAdd)
                    
                }
            }
        } else {
            print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
        }
    }
    
    func getImagePath(productToAdd: Product){
        let storageRef = Storage.storage().reference(withPath: productToAdd.name)
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            addProduct(productToAdd: productToAdd, imagePath: imageURL)
        }
        )
        
    }
    
    func updateData(productToUpdate: Product, isVisible: Bool){
        //Set the data to update
        db.collection("ImHörnken").document("Menu").collection("Products").document(productToUpdate.id ?? "").setData(["isVisible": isVisible] , merge: true) { error in

            //Check for Errors
            if error == nil{

                //Get the new data
                self.fetchProductsData()
            }
        }
    }
    
    //MARK: Additive
    
    func fetchAdditivesData() {
        db.collection("ImHörnken").document("Menu").collection("Additives").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Zusatzstoffe gefunden!")
                return
            }
            
            self.additives = documents.compactMap { queryDocumentSnapshot -> Additive? in
                return try? queryDocumentSnapshot.data(as: Additive.self)
                
            }
            
        }
    }
    
    func addAdditive(additiveToAdd: Additive) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Additives")
        do {
            let newDocReference = try collectionRef.addDocument(from: additiveToAdd)
            print("Zusatzstoff wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error")
        }
    }
    
    func deleteAdditive(additiveToDelete: Additive){
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
            else{
                print("Error: Zusatstoff konnte nicht gelöscht werden!")
            }
        }
        
    }
    
    //MARK: Allergen
    
    func fetchAllergensData() {
        db.collection("ImHörnken").document("Menu").collection("Allergens").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Allergene gefunden!")
                return
            }
            
            self.allergens = documents.compactMap { queryDocumentSnapshot -> Allergen? in
                return try? queryDocumentSnapshot.data(as: Allergen.self)
                
            }
            
        }
    }
    
    func addAllergen(allergenToAdd: Allergen) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Allergens")
        do {
            let newDocReference = try collectionRef.addDocument(from: allergenToAdd)
            print("Allergen wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Allergen wurde erfolgreich hinzugefügt!")
        }
    }
    
    func deleteAllergen(allergenToDelete: Allergen){
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
                print("Allergen wurde erfolgreich gelöscht!")
                
            }
            else{
                print("Error: Allergen konnte nicht gelöscht werden!")
            }
        }
        
    }
    
    //MARK: Category
    
    func fetchCategoriesData() {
        db.collection("ImHörnken").document("Menu").collection("Categories").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Kategorien gefunden!")
                return
            }
            
            self.categories = documents.compactMap { queryDocumentSnapshot -> Category? in
                return try? queryDocumentSnapshot.data(as: Category.self)
                
            }
            
        }
    }
    
    func addCategory(categoryToAdd: Category) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Categories")
        do {
            let newDocReference = try collectionRef.addDocument(from: categoryToAdd)
            print("Kategorie wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Kategorie konnte nicht hinzugefügt werden!")
        }
    }
    
    func deleteCategory(categoryToDelete: Category){
        //Specify the document to delete
        db.collection("ImHörnken").document("Menu").collection("Categories").document(categoryToDelete.id ?? "").delete { error in
            //Check for Errors
            if error == nil{
                //No errors
                
                //Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    //Remove the product that wass just deleted
                    self.categories.removeAll { i in
                        // Check for product to remove
                        return i.id == categoryToDelete.id
                    }
                }
                print("Kategorie wurde erfolgreich gelöscht!")
                
            }
            else{
                print("Error: Kategorie konnte nicht gelöscht werden!")
            }
        }
        
    }
    
    //MARK: Offer
    
    func fetchOffersData() {
        db.collection("ImHörnken").document("Menu").collection("Offers").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Angebote nicht gefunden!")
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
            print("Angebot wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Angebot konnte nicht hinzugefügt werden!")
        }
    }
    
    func deleteOffer(offerToDelete: Offer){
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
                print("Angebot wurde erfolgreich gelöscht!")
                
            }
            else{
                print("Error: Angebot konnte nicht gelöscht werden!")
            }
        }
        
    }
    
    //MARK: Topping
    
    func fetchToppingsData() {
        db.collection("ImHörnken").document("Menu").collection("Toppings").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Toppings nicht gefunden!")
                return
            }
            
            self.toppings = documents.compactMap { queryDocumentSnapshot -> Topping? in
                return try? queryDocumentSnapshot.data(as: Topping.self)
                
            }
            
        }
    }

    func addTopping(toppingToAdd: Topping) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Toppings")
        do {
            let newDocReference = try collectionRef.addDocument(from: toppingToAdd)
            print("Topping wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Topping konnte nicht hinzugefügt werden!")
        }
    }
    
    func deleteTopping(toppingToDelete: Topping){
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
                print("Topping wurde erfolgreich gelöscht!")
            }
            else{
                print("Error: Angebot konnte nicht gelöscht werden!")
            }
        }
        
    }
    
}
