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
import FirebaseAuth

class ModelData: ObservableObject{
    
    @Published var offers = [Offer]()
    @Published var products = [Product]()
    @Published var allergens = [Allergen]()
    @Published var additives = [Additive]()
    @Published var categories = [Category]()
    @Published var toppings = [Topping]()
    @Published var units = [Unit]()
    
    var menuId: String = ""
    
    var loggedInUser = Auth.auth().currentUser
    
    var loading = false
    
    //Reference to Cloud Firestore
    var db = Firestore.firestore()
    
    init(menuId:String){
        self.menuId = menuId
    }
    
    //MARK: Product
    
    // Fetch products from Cloud Firestore.
    func fetchProductsData() {
        if loggedInUser != nil{
            db.collection(menuId ).document("Menu").collection("Products").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Produkte gefunden!")
                return
            }
            
            self.products = documents.compactMap { queryDocumentSnapshot -> Product? in
                return try? queryDocumentSnapshot.data(as: Product.self)
            }
            
        }}
    }
    
    // Creates product and upload it to Cloud Firestore.
    func addProduct(productToAdd: Product, imagePath: String?, modelPath: String?){
        let product = Product(image: imagePath, model: modelPath, name: productToAdd.name, category: productToAdd.category, price: productToAdd.price,description: productToAdd.description, servingSizes: productToAdd.servingSizes, isVegan: productToAdd.isVegan, isBio: productToAdd.isBio, isFairtrade: productToAdd.isFairtrade, isVisible: productToAdd.isVisible, nutritionFacts: productToAdd.nutritionFacts, allergens: productToAdd.allergens, additives: productToAdd.additives, toppings: productToAdd.toppings)
        let collectionRef = db.collection(menuId ).document("Menu").collection("Products")
        do {
            let newDocReference = try collectionRef.addDocument(from: product)
            print("Produkt hinzugefügt mit folgender Referenz: \(newDocReference)")

            loading = false
        }
        catch {
            print(error)
            print("Error: Produkt konnte nicht hinzugefügt werden!")
        }
    }
    
    // First called controller when you try to add a product.
    func addProductController(productToAdd: Product, imageToAdd: UIImage?, modelToAdd: URL?)    {
        loading = true
        uploadImageProduct(image: imageToAdd, productToAdd: productToAdd, modelURL: modelToAdd)
    }
    
    // Upload image to Firebase Storage.
    func uploadImageProduct(image:UIImage?, productToAdd: Product, modelURL: URL?) {
        // Check if there is an image to upload.
        if let image = image {
            if let imageData = image.jpegData(compressionQuality: 1){
                let storage = Storage.storage()
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                // Upload image to Firebase Storage.
                storage.reference().child("ProductImages/" + image.description + ".jpg").putData(imageData, metadata: metadata){
                    (_, err) in
                    if let err = err {
                        print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                    } else {
                        print("Bild wurde erfolgreich hochgeladen!")
                        print(image)
                        
                        //Check if there is also a model.
                        if let model = modelURL {
                            guard model.startAccessingSecurityScopedResource(),
                                  let data = try? Data(contentsOf: model) else { return }
                            model.stopAccessingSecurityScopedResource()
                            
                            let storageRef = Storage.storage().reference()
                            
                            let metadata = StorageMetadata()
                            metadata.contentType = "model/vnd.usdz+zip"
                            
                            let riversRef = storageRef.child("3DModels/" + model.lastPathComponent)
                            
                            // Upload model to Firebase Storage.
                            _ = riversRef.putData(data, metadata: metadata) { (metadata, error) in
                                if let error = error{
                                    print("Error: Modell konnte nicht hochgeladen werden!\(error.localizedDescription)")
                                }
                                else {
                                    print("Modell wurde erfolgreich hochgeladen!")
                                    // Get path of image and product from Firebase Storage.
                                    self.getImageAndModelPathProduct(productToAdd: productToAdd, modelURL: model, image: image)
                                }
                                
                            }
                        }
                        else{
                            // Get the path of the image only.
                            self.getImagePathProduct(productToAdd: productToAdd, image: image)
                        }
                    }
                }
            } else {
                print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
            }
        }
        // Check if there is only a model to upload.
        else if let model = modelURL{
            // Call method to upload model to Firebase Storage.
            self.uploadModel(modelURL: model, productToAdd: productToAdd)
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                // Call method to add a product without model and image path.
                self.addProduct(productToAdd: productToAdd, imagePath: nil, modelPath: nil)
            }
        }
    }
    
    // Upload model to Firebase Storage.
    func uploadModel(modelURL: URL?, productToAdd: Product){
        
        // Make the security scoped resource available to your app
        guard modelURL!.startAccessingSecurityScopedResource(),
              let data = try? Data(contentsOf: modelURL!) else { return }
        modelURL!.stopAccessingSecurityScopedResource()
        
        // Reference to Firebase Storage.
        let storageRef = Storage.storage().reference()
        
        let metadata = StorageMetadata()
        
        metadata.contentType = "model/vnd.usdz+zip"
        
        // Upload model into the file named "3DModels".
        let riversRef = storageRef.child("3DModels/" + modelURL!.lastPathComponent)
        
        _ = riversRef.putData(data, metadata: metadata) { (metadata, error) in
            if let error = error{
                print("Error: Modell konnte nicht hochgeladen werden!\(error.localizedDescription)")
            }
            else {
                print("Modell wurde erfolgreich hochgeladen!")
                // Call method to get modelpath from Firebase Storage.
                self.getModelPathProduct(productToAdd: productToAdd, localURL: modelURL!)
            }
            
        }
    }
    
    // Get modelpath from Firebase Storage.
    func getModelPathProduct(productToAdd: Product, localURL: URL){
        let storageRef = Storage.storage().reference(withPath: "3DModels/" + localURL.lastPathComponent)
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Modellpfad konnte nicht ermittelt werden!")
                return
            }
            
            let modelURL = url.absoluteString
            print("Modellpfad wurde erfolgreich ermittelt!")
            // Call method to add a product.
            addProduct(productToAdd: productToAdd, imagePath: nil, modelPath: modelURL)
        }
        )
    }
    
    // Get imagepath from Firebase Storage.
    func getImagePathProduct(productToAdd: Product, image: UIImage){
        let storageRef = Storage.storage().reference(withPath: "ProductImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            // Call method to add a product.
            addProduct(productToAdd: productToAdd, imagePath: imageURL, modelPath: nil)
        }
        )}
    
    // Get image and model path from Firebase Storage.
    func getImageAndModelPathProduct(productToAdd: Product, modelURL: URL, image: UIImage){
        // Upload image to file named "ProductImages".
        let storageRef = Storage.storage().reference(withPath: "ProductImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            
            // Upload Model to file named "3DModels".
            let storageRef = Storage.storage().reference(withPath: "3DModels/" + modelURL.lastPathComponent)
            storageRef.downloadURL(completion: { [self] url, error in
                guard let url = url, error == nil else {
                    print("Error: Modellpfad konnte nicht ermittelt werden!")
                    return
                }
                let modelString = url.absoluteString
                print("Modellpfad wurde erfolgreich ermittelt!")
                // Call method to add product
                addProduct(productToAdd: productToAdd, imagePath: imageURL, modelPath: modelString)
            }
            )}
        )
        
    }
    
    func deleteProduct(productToDelete: Product){
        // Specify the document to delete.
        db.collection(menuId).document("Menu").collection("Products").document(productToDelete.id ?? "").delete { error in
            // Check for Errors.
            if error == nil{
                // No errors
                
                // Update the UI from the main thread.
                DispatchQueue.main.async {
                    
                    // Remove the product that wass just deleted.
                    self.products.removeAll { i in
                        // Check for product to remove.
                        return i.id == productToDelete.id
                    }
                }
                print("Produkt wurde erfolgreich gelöscht!")
            }
            else{
                print("Error: Produkt konnte nicht gelöscht werden!")
            }
        }
        // If image was available, delete from Firebase Storage
        let storage = Storage.storage()
        
        if productToDelete.image != nil{
            storage.reference(forURL: productToDelete.image!).delete { error in
                if error != nil {
                    print("Error: Bild konnte nicht gelöscht werden!")
                } else {
                    print("Bild wurde erfolgreich gelöscht!")
                }
            }
        }
        
        // If model was available, delete from Firebase Storage.
        if productToDelete.model != nil{
            storage.reference(forURL: productToDelete.model!).delete { error in
                if error != nil {
                    print("Error: Modell konnte nicht gelöscht werden!")
                } else {
                    print("Modell wurde erfolgreich gelöscht!")
                }
            }
        }
        
    }
    
    func updateProduct(productToUpdate: Product){
        if let documentId = productToUpdate.id {
            do {
                try db.collection(menuId).document("Menu").collection("Products").document(documentId).setData(from: productToUpdate)
                print("Produkt wurde erfolgreich aktualisiert!")
                loading = false
            }
            catch {
                print("Error: Produkt konnte nicht aktualsiert werden!" + error.localizedDescription)
            }
        }
    }
    
    // First called controller when you try to update product.
    func updateProductController(productToUpdate: Product, imageToUpdate: UIImage?, modelToUpdate: URL?) {
        loading = true
        // If image and model should not be updated.
        if imageToUpdate == nil && modelToUpdate == nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.updateProduct(productToUpdate: productToUpdate)
                
            }
        }
        // If image or model should be updated.
        else if imageToUpdate != nil || modelToUpdate != nil{
            updateImageAndModelProduct(imageToUpdate: imageToUpdate, productToUpdate: productToUpdate, modelToUpdate: modelToUpdate)
        }
        
    }
    
    
    func updateImageAndModelProduct(imageToUpdate: UIImage?, productToUpdate: Product, modelToUpdate: URL?){
        // If image and model should be updated.
        if imageToUpdate != nil && modelToUpdate != nil{
            if let imageData = imageToUpdate!.jpegData(compressionQuality: 1){
                let storage = Storage.storage()
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                // Upload image to Firebase Storage.
                storage.reference().child("ProductImages/" + imageToUpdate!.description + ".jpg").putData(imageData, metadata: metadata){
                    (_, err) in
                    if let err = err {
                        print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                    } else {
                        print("Bild wurde erfolgreich hochgeladen!")
                        
                        // Upload model to Firebase Storage.
                        guard modelToUpdate!.startAccessingSecurityScopedResource(),
                              let data = try? Data(contentsOf: modelToUpdate!) else { return }
                        modelToUpdate!.stopAccessingSecurityScopedResource()
                        
                        let storageRef = Storage.storage().reference()
                        
                        let metadata = StorageMetadata()
                        metadata.contentType = "model/vnd.usdz+zip"
                        
                        let riversRef = storageRef.child("3DModels/" + modelToUpdate!.lastPathComponent)
                        
                        _ = riversRef.putData(data, metadata: metadata) { (metadata, error) in
                            if let error = error{
                                print("Error: Modell konnte nicht hochgeladen werden!\(error.localizedDescription)")
                            }
                            else {
                                print("Modell wurde erfolgreich hochgeladen!")
                                // Call method to get model and image path.
                                self.getUpdatedImageAndModelPath(productToUpdate: productToUpdate, image: imageToUpdate!, model: modelToUpdate!)
                            }
                        }
                        
                    }
                }
            } else {
                print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
            }
        }
        // If model should be updated.
        else if modelToUpdate != nil{
            guard modelToUpdate!.startAccessingSecurityScopedResource(),
                  let data = try? Data(contentsOf: modelToUpdate!) else { return }
            modelToUpdate!.stopAccessingSecurityScopedResource()
            
            let storageRef = Storage.storage().reference()
            
            let metadata = StorageMetadata()
            metadata.contentType = "model/vnd.usdz+zip"
            
            let riversRef = storageRef.child("3DModels/" + modelToUpdate!.lastPathComponent)
            // Upload model to Firebase Storage.
            _ = riversRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error{
                    print("Error: Modell konnte nicht hochgeladen werden!\(error.localizedDescription)")
                }
                else {
                    print("Modell wurde erfolgreich hochgeladen!")
                    self.getUpdatedModelPath(productToUpdate: productToUpdate, model: modelToUpdate!)
                }
            }
        }
        // If image should be updated.
        else if imageToUpdate != nil{
            if let imageData = imageToUpdate!.jpegData(compressionQuality: 1){
                let storage = Storage.storage()
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                storage.reference().child("ProductImages/" + imageToUpdate!.description + ".jpg").putData(imageData, metadata: metadata){
                    (_, err) in
                    if let err = err {
                        print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                    } else {
                        print("Bild wurde erfolgreich hochgeladen!")
                        self.getUpdatedImagePath(productToUpdate: productToUpdate, image: imageToUpdate!)
                    }
                }
            } else {
                print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
            }
        }
        
    }
    
    
    func getUpdatedImagePath(productToUpdate: Product, image: UIImage){
        let storageRef = Storage.storage().reference(withPath: "ProductImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            
            // Create product with updated image.
            let updatedProduct = Product(id: productToUpdate.id, image: imageURL, model: productToUpdate.model, name: productToUpdate.name, category: productToUpdate.category, price: productToUpdate.price, description: productToUpdate.description, servingSizes: productToUpdate.servingSizes, isVegan: productToUpdate.isVegan, isBio: productToUpdate.isBio, isFairtrade: productToUpdate.isFairtrade, isVisible: productToUpdate.isVisible, nutritionFacts: productToUpdate.nutritionFacts, allergens: productToUpdate.allergens, additives: productToUpdate.additives, toppings: productToUpdate.toppings)
            
            // Call method to update product.
            updateProduct(productToUpdate: updatedProduct)
            
        }
        )
    }
    
    func getUpdatedImageAndModelPath(productToUpdate: Product, image: UIImage, model: URL){
        // Get updated image path.
        let storageRef = Storage.storage().reference(withPath: "ProductImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            
            // Get updated model path.
            let storageRef = Storage.storage().reference(withPath: "3DModels/" + model.lastPathComponent)
            storageRef.downloadURL(completion: { [self] url, error in
                guard let url = url, error == nil else {
                    print("Error: Modellpfad konnte nicht ermittelt werden!")
                    return
                }
                let modelURL = url.absoluteString
                print("Modellpfad wurde erfolgreich ermittelt!")
                
                // Create product with updated image and model.
                let updatedProduct = Product(id: productToUpdate.id, image: imageURL, model: modelURL, name: productToUpdate.name, category: productToUpdate.category, price: productToUpdate.price, description: productToUpdate.description, servingSizes: productToUpdate.servingSizes, isVegan: productToUpdate.isVegan, isBio: productToUpdate.isBio, isFairtrade: productToUpdate.isFairtrade, isVisible: productToUpdate.isVisible, nutritionFacts: productToUpdate.nutritionFacts, allergens: productToUpdate.allergens, additives: productToUpdate.additives, toppings: productToUpdate.toppings)
                
                updateProduct(productToUpdate: updatedProduct)
            }
            )}
        )
    }
    
    func getUpdatedModelPath(productToUpdate: Product, model: URL){
        let storageRef = Storage.storage().reference(withPath: "3DModels/" + model.lastPathComponent)
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Modellpfad konnte nicht ermittelt werden!")
                return
            }
            let modelURL = url.absoluteString
            print("Modellpfad wurde erfolgreich ermittelt!")
            
            // Create product with updated model.
            let updatedProduct = Product(id: productToUpdate.id, image: productToUpdate.image, model: modelURL, name: productToUpdate.name, category: productToUpdate.category, price: productToUpdate.price, description: productToUpdate.description, servingSizes: productToUpdate.servingSizes, isVegan: productToUpdate.isVegan, isBio: productToUpdate.isBio, isFairtrade: productToUpdate.isFairtrade, isVisible: productToUpdate.isVisible, nutritionFacts: productToUpdate.nutritionFacts, allergens: productToUpdate.allergens, additives: productToUpdate.additives, toppings: productToUpdate.toppings)
            
            updateProduct(productToUpdate: updatedProduct)
        }
        )
        
    }
    
    //MARK: Additive
    
    // Fetch additives from Cloud Firestore.
    func fetchAdditivesData() {
        if loggedInUser != nil{
            db.collection(menuId).document("Menu").collection("Additives").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Zusatzstoffe gefunden!")
                return
            }
            
            // Add additives from database into additives array.
            self.additives = documents.compactMap { queryDocumentSnapshot -> Additive? in
                return try? queryDocumentSnapshot.data(as: Additive.self)
                
            }
            
        }}
    }
    
    // Add additive to Cloud Firestore.
    func addAdditive(additiveToAdd: Additive) {
        let collectionRef = db.collection(menuId).document("Menu").collection("Additives")
        do {
            let newDocReference = try collectionRef.addDocument(from: additiveToAdd)
            print("Zusatzstoff wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error")
        }
    }
    
    // Delete additives from Cloud Firestore.
    func deleteAdditive(additiveToDelete: Additive){
        // Specify the document to delete.
        db.collection(menuId).document("Menu").collection("Additives").document(additiveToDelete.id ?? "").delete { error in
            // Check for Errors
            if error == nil{
                // No errors.
                
                // Update the UI from the main thread.
                DispatchQueue.main.async {
                    
                    //Remove the product that wass just deleted.
                    self.additives.removeAll { i in
                        // Check for product to remove.
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
    
    // Fetch allergens from Cloud Firestore.
    func fetchAllergensData() {
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Allergens").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Allergene gefunden!")
                return
            }
            
            // Add allergens from database into allergens array.
            self.allergens = documents.compactMap { queryDocumentSnapshot -> Allergen? in
                return try? queryDocumentSnapshot.data(as: Allergen.self)
                
            }
            
        }}
    }
    
    // Add allergen to Cloud Firestore.
    func addAllergen(allergenToAdd: Allergen) {
        let collectionRef = db.collection(menuId).document("Menu").collection("Allergens")
        do {
            let newDocReference = try collectionRef.addDocument(from: allergenToAdd)
            print("Allergen wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Allergen wurde erfolgreich hinzugefügt!")
        }
    }
    
    // Delete allergen from Cloud Firestore.
    func deleteAllergen(allergenToDelete: Allergen){
        // Specify the document to delete.
        db.collection(menuId).document("Menu").collection("Allergens").document(allergenToDelete.id ?? "").delete { error in
            // Check for Errors.
            if error == nil{
                // No errors.
                
                // Update the UI from the main thread.
                DispatchQueue.main.async {
                    
                    // Remove the product that was just deleted.
                    self.allergens.removeAll { i in
                        // Check for product to remove.
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
    
    // Fetch categories from Cloud Firestore.
    func fetchCategoriesData() {
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Categories").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Kategorien gefunden!")
                return
            }
            
            // Add categories from database to categories array.
            self.categories = documents.compactMap { queryDocumentSnapshot -> Category? in
                return try? queryDocumentSnapshot.data(as: Category.self)
                
            }
            
        }}
    }
    
    // Add category to Cloud Firestore.
    func addCategory(categoryToAdd: Category) {
        let collectionRef = db.collection(menuId).document("Menu").collection("Categories")
        do {
            let newDocReference = try collectionRef.addDocument(from: categoryToAdd)
            print("Kategorie wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Kategorie konnte nicht hinzugefügt werden!")
        }
    }
    
    // Delete category from Cloud Firestore.
    func deleteCategory(categoryToDelete: Category){
        // Specify the document to delete.
        db.collection(menuId).document("Menu").collection("Categories").document(categoryToDelete.id ?? "").delete { error in
            // Check for Errors.
            if error == nil{
                // No errors.
                
                // Update the UI from the main thread.
                DispatchQueue.main.async {
                    
                    // Remove the product that wass just deleted.
                    self.categories.removeAll { i in
                        // Check for product to remove.
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
    
    // Fetch offers from Cloud Firestore.
    func fetchOffersData() {
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Offers").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Angebote nicht gefunden!")
                return
            }
            
            // Add offers from database to offers array.
            self.offers = documents.compactMap { queryDocumentSnapshot -> Offer? in
                
                return try? queryDocumentSnapshot.data(as: Offer.self)
            }
        }}
    }
    
    // First called controller when you try to add an offer.
    func addOfferController(offerToAdd: Offer, imageToAdd: UIImage?)    {
        loading = true
        uploadImageOffer(image: imageToAdd, offerToAdd: offerToAdd)
    }
    
    // Add offer to Cloud Firestore.
    func addOffer(offerToAdd: Offer, imagePath: String?){
        
        let offer = Offer(image: imagePath, title: offerToAdd.title, description: offerToAdd.description, products: offerToAdd.products, isVisible: offerToAdd.isVisible)
        let collectionRef = db.collection(menuId).document("Menu").collection("Offers")
        do {
            let newDocReference = try collectionRef.addDocument(from: offer)
            print("Angebot hinzugefügt mit folgender Referenz: \(newDocReference)")
            loading = false
        }
        catch {
            print(error)
            print("Error: Angebot konnte nicht hinzugefügt werden!")
        }
    }
    
    // Delete offer from Cloud Firestore.
    func deleteOffer(offerToDelete: Offer){
        // Specify the document to delete.
        db.collection(menuId).document("Menu").collection("Offers").document(offerToDelete.id ?? "").delete { error in
            // Check for Errors.
            if error == nil{
                //No errors
                
                // Update the UI from the main thread.
                DispatchQueue.main.async {
                    
                    // Remove the product that was just deleted.
                    self.offers.removeAll { i in
                        // Check for product to remove.
                        return i.id == offerToDelete.id
                    }
                }
                print("Angebot wurde erfolgreich gelöscht!")
                
            }
            else{
                print("Error: Angebot konnte nicht gelöscht werden!")
            }
        }
        // Check if the offer had an image
        if offerToDelete.image != nil{
            // Delete image from Firebase Storage.
            let storage = Storage.storage()
            storage.reference(forURL: offerToDelete.image!).delete { error in
                if error != nil {
                    print("Error: Bild konnte nicht gelöscht werden!")
                } else {
                    print("Bild wurde erfolgreich gelöscht!")
                }
            }
        }
        
    }
    
    // Upload offer image to Firebase Storage.
    func uploadImageOffer(image: UIImage?, offerToAdd: Offer) {
        if let image = image{
            if let imageData = image.jpegData(compressionQuality: 1){
                let storage = Storage.storage()
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                storage.reference().child("OfferImages/" + image.description + ".jpg").putData(imageData, metadata: metadata){
                    (_, err) in
                    if let err = err {
                        print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                    } else {
                        print("Bild wurde erfolgreich hochgeladen!")
                        // Call method to get image path.
                        self.getImagePathOffer(offerToAdd: offerToAdd, image: image)
                        
                        
                    }
                }
            }else {
                print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
            }}
        else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                // Call method to add offer.
                self.addOffer(offerToAdd: offerToAdd, imagePath: nil)
            }
        }
    }
    
    // Get image path of the offer from Firebase Storage.
    func getImagePathOffer(offerToAdd: Offer, image: UIImage){
        let storageRef = Storage.storage().reference(withPath: "OfferImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            // Call method to add offer.
            addOffer(offerToAdd: offerToAdd, imagePath: imageURL)
        }
        )
        
    }
    
    // First method called when you try to update an offer.
    func updateOfferController(offerToUpdate: Offer, imageToUpdate: UIImage?){
        loading = true
        // Check if image should be updated.
        if imageToUpdate == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                // Call method to update offer.
                self.updateOffer(offer: offerToUpdate)
            }
        }
        else{
            // Call method to update the image of the offer.
            updateImageOffer(offerToUpdate: offerToUpdate, imageToUpdate: imageToUpdate!)
        }
    }
    
    // Update the image of the offer.
    func updateImageOffer(offerToUpdate: Offer, imageToUpdate: UIImage){
        // Upload image to Firebase Storage.
        if let imageData = imageToUpdate.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storage.reference().child("OfferImages/" + imageToUpdate.description + ".jpg").putData(imageData, metadata: metadata){
                (_, err) in
                if let err = err {
                    print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                } else {
                    print("Bild wurde erfolgreich hochgeladen!")
                    // Get image path from Firebase Storage.
                    let storageRef = Storage.storage().reference(withPath: "OfferImages/" + imageToUpdate.description + ".jpg")
                    storageRef.downloadURL(completion: { [self] url, error in
                        guard let url = url, error == nil else {
                            print("Error: Bildpfad konnte nicht ermittelt werden!")
                            return
                        }
                        let imageURL = url.absoluteString
                        print("Bildpfad wurde erfolgreich ermittelt!")
                        
                        // Create offer with updated image.
                        let updatedOffer = Offer(id: offerToUpdate.id, image: imageURL, title: offerToUpdate.title, description: offerToUpdate.description, products: offerToUpdate.products, isVisible: offerToUpdate.isVisible)
                        
                        // Call method to update offer.
                        updateOffer(offer: updatedOffer)
                    }
                    )
                }
            }
        } else {
            print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
        }
    }
    
    // Update offer
    func updateOffer(offer: Offer) {
        // Check documentID of the offer
        if let documentId = offer.id {
            do {
                try db.collection(menuId).document("Menu").collection("Offers").document(documentId).setData(from: offer)
                print("Angebot wurde erfolgreich aktualisiert!")
                
                loading = false
            }
            catch {
                print(error)
            }
        }
    }
    
    //MARK: Topping
    
    // Fetch toppings from Cloud Firestore.
    func fetchToppingsData() {
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Toppings").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Toppings nicht gefunden!")
                return
            }
            
            // Add toppings from database to toppings array.
            self.toppings = documents.compactMap { queryDocumentSnapshot -> Topping? in
                return try? queryDocumentSnapshot.data(as: Topping.self)
                
            }
            
        }}
    }
    
    // Add topping to Cloud Firestore.
    func addTopping(toppingToAdd: Topping) {
        let collectionRef = db.collection(menuId).document("Menu").collection("Toppings")
        do {
            let newDocReference = try collectionRef.addDocument(from: toppingToAdd)
            print("Topping wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Topping konnte nicht hinzugefügt werden!")
        }
    }
    
    // Delete topping from Cloud Firestore.
    func deleteTopping(toppingToDelete: Topping){
        // Specify the document to delete.
        db.collection(menuId).document("Menu").collection("Toppings").document(toppingToDelete.id ?? "").delete { error in
            // Check for Errors.
            if error == nil{
                // No errors.
                
                // Update the UI from the main thread.
                DispatchQueue.main.async {
                    
                    // Remove the product that wass just deleted.
                    self.toppings.removeAll { i in
                        // Check for product to remove.
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
    
    //MARK: Unit
    
    // Fetch units from Cloud Firestore.
    func fetchUnitsData() {
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Units").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Units nicht gefunden!")
                return
            }
            
            // Add units from databse to units array.
            self.units = documents.compactMap { queryDocumentSnapshot -> Unit? in
                return try? queryDocumentSnapshot.data(as: Unit.self)
                
            }
            
        }}
    }
    
    // Add unit to Cloud Firestore.
    func addUnit(unitToAdd: Unit) {
        let collectionRef = db.collection(menuId).document("Menu").collection("Units")
        do {
            let newDocReference = try collectionRef.addDocument(from: unitToAdd)
            print("Unit wurde erfolgreich mit folgender Referenz hinzugefügt: \(newDocReference)")
        }
        catch {
            print(error)
            print("Error: Unit wurde erfolgreich hinzugefügt!")
        }
    }
    
    // Delete unit from Cloud Firestore.
    func deleteUnit(unitToDelete: Unit){
        // Specify the document to delete.
        db.collection(menuId).document("Menu").collection("Units").document(unitToDelete.id ?? "").delete { error in
            // Check for Errors.
            if error == nil{
                // No errors.
                
                // Update the UI from the main thread.
                DispatchQueue.main.async {
                    
                    // Remove the product that wass just deleted.
                    self.units.removeAll { i in
                        // Check for product to remove
                        return i.id == unitToDelete.id
                    }
                }
                print("Unit wurde erfolgreich gelöscht!")
                
            }
            else{
                print("Error: Unit konnte nicht gelöscht werden!")
            }
        }
        
    }
    
    
}
