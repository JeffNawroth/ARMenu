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

    var db = Firestore.firestore()
    
    init(menuId:String){
        self.menuId = menuId
    }
    
    //MARK: Product
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
    
    func addProductController(productToAdd: Product, imageToAdd: UIImage?, modelToAdd: URL?)    {
        loading = true
        uploadImageProduct(image: imageToAdd, productToAdd: productToAdd, modelURL: modelToAdd)
    }
    
    func uploadImageProduct(image:UIImage?, productToAdd: Product, modelURL: URL?) {
        if let image = image {
            if let imageData = image.jpegData(compressionQuality: 1){
                let storage = Storage.storage()
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                storage.reference().child("ProductImages/" + image.description + ".jpg").putData(imageData, metadata: metadata){
                    (_, err) in
                    if let err = err {
                        print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                    } else {
                        print("Bild wurde erfolgreich hochgeladen!")
                        print(image)
                        if let model = modelURL {
                            guard model.startAccessingSecurityScopedResource(),
                                  let data = try? Data(contentsOf: model) else { return }
                            model.stopAccessingSecurityScopedResource()
                            
                            let storageRef = Storage.storage().reference()
                            
                            let metadata = StorageMetadata()
                            metadata.contentType = "model/vnd.usdz+zip"
                            
                            let riversRef = storageRef.child("3DModels/" + model.lastPathComponent)
                            
                            _ = riversRef.putData(data, metadata: metadata) { (metadata, error) in
                                if let error = error{
                                    print("Error: Modell konnte nicht hochgeladen werden!\(error.localizedDescription)")
                                }
                                else {
                                    print("Modell wurde erfolgreich hochgeladen!")
                                    self.getImageAndModelPathProduct(productToAdd: productToAdd, modelURL: model, image: image)
                                }
                                
                            }
                        }
                        else{
                            self.getImagePathProduct(productToAdd: productToAdd, image: image)
                        }
                    }
                }
            } else {
                print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
            }
        }
        else if let model = modelURL{
            self.uploadModel(modelURL: model, productToAdd: productToAdd)
        }
        else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.addProduct(productToAdd: productToAdd, imagePath: nil, modelPath: nil)
            }
        }
    }
    
    func uploadModel(modelURL: URL?, productToAdd: Product){
        
        guard modelURL!.startAccessingSecurityScopedResource(),
              let data = try? Data(contentsOf: modelURL!) else { return }
        modelURL!.stopAccessingSecurityScopedResource()
        
        let storageRef = Storage.storage().reference()
        
        let metadata = StorageMetadata()
        metadata.contentType = "model/vnd.usdz+zip"
        
        let riversRef = storageRef.child("3DModels/" + modelURL!.lastPathComponent)
        
        _ = riversRef.putData(data, metadata: metadata) { (metadata, error) in
            if let error = error{
                print("Error: Modell konnte nicht hochgeladen werden!\(error.localizedDescription)")
            }
            else {
                print("Modell wurde erfolgreich hochgeladen!")
                self.getModelPathProduct(productToAdd: productToAdd, localURL: modelURL!)
            }
            
        }
    }
    
    func getModelPathProduct(productToAdd: Product, localURL: URL){
        let storageRef = Storage.storage().reference(withPath: "3DModels/" + localURL.lastPathComponent)
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Modellpfad konnte nicht ermittelt werden!")
                return
            }
            let modelURL = url.absoluteString
            print("Modellpfad wurde erfolgreich ermittelt!")
            addProduct(productToAdd: productToAdd, imagePath: nil, modelPath: modelURL)
        }
        )
    }
    
    func getImagePathProduct(productToAdd: Product, image: UIImage){
        //Bildpfad ermitteln
        let storageRef = Storage.storage().reference(withPath: "ProductImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            addProduct(productToAdd: productToAdd, imagePath: imageURL, modelPath: nil)
        }
        )}
    
    func getImageAndModelPathProduct(productToAdd: Product, modelURL: URL, image: UIImage){
        //Bildpfad ermitteln
        let storageRef = Storage.storage().reference(withPath: "ProductImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            let storageRef = Storage.storage().reference(withPath: "3DModels/" + modelURL.lastPathComponent)
            storageRef.downloadURL(completion: { [self] url, error in
                guard let url = url, error == nil else {
                    print("Error: Modellpfad konnte nicht ermittelt werden!")
                    return
                }
                let modelString = url.absoluteString
                print("Modellpfad wurde erfolgreich ermittelt!")
                addProduct(productToAdd: productToAdd, imagePath: imageURL, modelPath: modelString)
            }
            )}
        )
        
    }
    
    func deleteProduct(productToDelete: Product){
        //Specify the document to delete
        db.collection(menuId).document("Menu").collection("Products").document(productToDelete.id ?? "").delete { error in
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
        
        if productToDelete.image != nil{
            storage.reference(forURL: productToDelete.image!).delete { error in
                if error != nil {
                    print("Error: Bild konnte nicht gelöscht werden!")
                } else {
                    print("Bild wurde erfolgreich gelöscht!")
                }
            }
        }
        
        if productToDelete.model != nil{
            //        storage.reference().child("3DModels/" + productToDelete.name! + ".usdz").delete { error in
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
    
    func updateProductController(productToUpdate: Product, imageToUpdate: UIImage?, modelToUpdate: URL?) {
        loading = true
        //Wenn Bild als auch Modell nicht aktualisiert werden muss
        if imageToUpdate == nil && modelToUpdate == nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.updateProduct(productToUpdate: productToUpdate)
                
            }
        }
        //Wenn Bild oder Modell aktualisiert werden muss
        else if imageToUpdate != nil || modelToUpdate != nil{
            updateImageAndModelProduct(imageToUpdate: imageToUpdate, productToUpdate: productToUpdate, modelToUpdate: modelToUpdate)
        }
        
    }
    
    
    func updateImageAndModelProduct(imageToUpdate: UIImage?, productToUpdate: Product, modelToUpdate: URL?){
        if imageToUpdate != nil && modelToUpdate != nil{
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
                                self.getUpdatedImageAndModelPath(productToUpdate: productToUpdate, image: imageToUpdate!, model: modelToUpdate!)
                            }
                        }
                        
                    }
                }
            } else {
                print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
            }
        }
        else if modelToUpdate != nil{
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
                    self.getUpdatedModelPath(productToUpdate: productToUpdate, model: modelToUpdate!)
                }
            }
        }
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
            
            let updatedProduct = Product(id: productToUpdate.id, image: imageURL, model: productToUpdate.model, name: productToUpdate.name, category: productToUpdate.category, price: productToUpdate.price, description: productToUpdate.description, servingSizes: productToUpdate.servingSizes, isVegan: productToUpdate.isVegan, isBio: productToUpdate.isBio, isFairtrade: productToUpdate.isFairtrade, isVisible: productToUpdate.isVisible, nutritionFacts: productToUpdate.nutritionFacts, allergens: productToUpdate.allergens, additives: productToUpdate.additives, toppings: productToUpdate.toppings)
            
            updateProduct(productToUpdate: updatedProduct)
            
        }
        )
    }
    
    func getUpdatedImageAndModelPath(productToUpdate: Product, image: UIImage, model: URL){
        let storageRef = Storage.storage().reference(withPath: "ProductImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            //Modellpfad ermitteln
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            
            let storageRef = Storage.storage().reference(withPath: "3DModels/" + model.lastPathComponent)
            storageRef.downloadURL(completion: { [self] url, error in
                guard let url = url, error == nil else {
                    print("Error: Modellpfad konnte nicht ermittelt werden!")
                    return
                }
                let modelURL = url.absoluteString
                print("Modellpfad wurde erfolgreich ermittelt!")
                
                let updatedProduct = Product(id: productToUpdate.id, image: imageURL, model: modelURL, name: productToUpdate.name, category: productToUpdate.category, price: productToUpdate.price, description: productToUpdate.description, servingSizes: productToUpdate.servingSizes, isVegan: productToUpdate.isVegan, isBio: productToUpdate.isBio, isFairtrade: productToUpdate.isFairtrade, isVisible: productToUpdate.isVisible, nutritionFacts: productToUpdate.nutritionFacts, allergens: productToUpdate.allergens, additives: productToUpdate.additives, toppings: productToUpdate.toppings)
                
                updateProduct(productToUpdate: updatedProduct)
            }
            )}
        )
    }
    
    func getUpdatedModelPath(productToUpdate: Product, model: URL){
        //Modellpfad ermitteln
        let storageRef = Storage.storage().reference(withPath: "3DModels/" + model.lastPathComponent)
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Modellpfad konnte nicht ermittelt werden!")
                return
            }
            let modelURL = url.absoluteString
            print("Modellpfad wurde erfolgreich ermittelt!")
            
            let updatedProduct = Product(id: productToUpdate.id, image: productToUpdate.image, model: modelURL, name: productToUpdate.name, category: productToUpdate.category, price: productToUpdate.price, description: productToUpdate.description, servingSizes: productToUpdate.servingSizes, isVegan: productToUpdate.isVegan, isBio: productToUpdate.isBio, isFairtrade: productToUpdate.isFairtrade, isVisible: productToUpdate.isVisible, nutritionFacts: productToUpdate.nutritionFacts, allergens: productToUpdate.allergens, additives: productToUpdate.additives, toppings: productToUpdate.toppings)
            
            updateProduct(productToUpdate: updatedProduct)
        }
        )
        
    }
    
    //MARK: Additive
    
    func fetchAdditivesData() {
        if loggedInUser != nil{
            db.collection(menuId).document("Menu").collection("Additives").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Zusatzstoffe gefunden!")
                return
            }
            
            self.additives = documents.compactMap { queryDocumentSnapshot -> Additive? in
                return try? queryDocumentSnapshot.data(as: Additive.self)
                
            }
            
        }}
    }
    
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
    
    func deleteAdditive(additiveToDelete: Additive){
        //Specify the document to delete
        db.collection(menuId).document("Menu").collection("Additives").document(additiveToDelete.id ?? "").delete { error in
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
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Allergens").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Allergene gefunden!")
                return
            }
            
            self.allergens = documents.compactMap { queryDocumentSnapshot -> Allergen? in
                return try? queryDocumentSnapshot.data(as: Allergen.self)
                
            }
            
        }}
    }
    
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
    
    func deleteAllergen(allergenToDelete: Allergen){
        //Specify the document to delete
        db.collection(menuId).document("Menu").collection("Allergens").document(allergenToDelete.id ?? "").delete { error in
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
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Categories").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Keine Kategorien gefunden!")
                return
            }
            
            self.categories = documents.compactMap { queryDocumentSnapshot -> Category? in
                return try? queryDocumentSnapshot.data(as: Category.self)
                
            }
            
        }}
    }
    
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
    
    func deleteCategory(categoryToDelete: Category){
        //Specify the document to delete
        db.collection(menuId).document("Menu").collection("Categories").document(categoryToDelete.id ?? "").delete { error in
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
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Offers").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Angebote nicht gefunden!")
                return
            }
            
            self.offers = documents.compactMap { queryDocumentSnapshot -> Offer? in
                
                return try? queryDocumentSnapshot.data(as: Offer.self)
            }
        }}
    }
    
    func addOfferController(offerToAdd: Offer, imageToAdd: UIImage?)    {
        loading = true
        uploadImageOffer(image: imageToAdd, offerToAdd: offerToAdd)
    }
    
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
    
    func deleteOffer(offerToDelete: Offer){
        //Specify the document to delete
        db.collection(menuId).document("Menu").collection("Offers").document(offerToDelete.id ?? "").delete { error in
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
        if offerToDelete.image != nil{
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
                        self.getImagePathOffer(offerToAdd: offerToAdd, image: image)
                        
                        
                    }
                }
            }else {
                print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
            }}
        else{
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.addOffer(offerToAdd: offerToAdd, imagePath: nil)
            }
        }
    }
    
    func getImagePathOffer(offerToAdd: Offer, image: UIImage){
        let storageRef = Storage.storage().reference(withPath: "OfferImages/" + image.description + ".jpg")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            addOffer(offerToAdd: offerToAdd, imagePath: imageURL)
        }
        )
        
    }
    
    func updateOfferController(offerToUpdate: Offer, imageToUpdate: UIImage?){
        loading = true
        if imageToUpdate == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                self.updateOffer(offer: offerToUpdate)
            }
        }
        else{
            updateImageOffer(offerToUpdate: offerToUpdate, imageToUpdate: imageToUpdate!)
        }
    }
    
    func updateImageOffer(offerToUpdate: Offer, imageToUpdate: UIImage){
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
                    let storageRef = Storage.storage().reference(withPath: "OfferImages/" + imageToUpdate.description + ".jpg")
                    storageRef.downloadURL(completion: { [self] url, error in
                        guard let url = url, error == nil else {
                            print("Error: Bildpfad konnte nicht ermittelt werden!")
                            return
                        }
                        let imageURL = url.absoluteString
                        print("Bildpfad wurde erfolgreich ermittelt!")
                        
                        let updatedOffer = Offer(id: offerToUpdate.id, image: imageURL, title: offerToUpdate.title, description: offerToUpdate.description, products: offerToUpdate.products, isVisible: offerToUpdate.isVisible)
                        
                        updateOffer(offer: updatedOffer)
                    }
                    )
                }
            }
        } else {
            print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
        }
    }
    
    func updateOffer(offer: Offer) {
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
    
    func fetchToppingsData() {
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Toppings").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Toppings nicht gefunden!")
                return
            }
            
            self.toppings = documents.compactMap { queryDocumentSnapshot -> Topping? in
                return try? queryDocumentSnapshot.data(as: Topping.self)
                
            }
            
        }}
    }
    
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
    
    func deleteTopping(toppingToDelete: Topping){
        //Specify the document to delete
        db.collection(menuId).document("Menu").collection("Toppings").document(toppingToDelete.id ?? "").delete { error in
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
    
    //MARK: Unit
    
    func fetchUnitsData() {
        if loggedInUser != nil{
        db.collection(menuId).document("Menu").collection("Units").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Units nicht gefunden!")
                return
            }
            
            self.units = documents.compactMap { queryDocumentSnapshot -> Unit? in
                return try? queryDocumentSnapshot.data(as: Unit.self)
                
            }
            
        }}
    }
    
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
    
    func deleteUnit(unitToDelete: Unit){
        //Specify the document to delete
        db.collection(menuId).document("Menu").collection("Units").document(unitToDelete.id ?? "").delete { error in
            //Check for Errors
            if error == nil{
                //No errors
                
                //Update the UI from the main thread
                DispatchQueue.main.async {
                    
                    //Remove the product that wass just deleted
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
