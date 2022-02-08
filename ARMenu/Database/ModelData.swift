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
    @Published var units = [Unit]()
    @Published var product: Product = Product(image: "", model: "", name: "", category: Category(name: ""), price: 0, description: "", servingSize: ServingSize(unit: Unit(name: "g"), size: 0), isVegan: false, isBio: false, isFairtrade: false, isVisible: false, nutritionFacts: NutritionFacts(calories: 0, fat: 0, carbs: 0, protein: 0), allergens: [], additives: [], toppings: [])
//    @Published var errorMessage: String?
    @Published var offerProducts = [Product]()
    
    
    
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
    
    func addProduct(productToAdd: Product, imagePath: String, modelPath: String){
        
        let product = Product(image: imagePath, model: modelPath, name: productToAdd.name, category: productToAdd.category, price: productToAdd.price,description: productToAdd.description, servingSize: productToAdd.servingSize, isVegan: productToAdd.isVegan, isBio: productToAdd.isBio, isFairtrade: productToAdd.isFairtrade, isVisible: productToAdd.isVisible, nutritionFacts: productToAdd.nutritionFacts, allergens: productToAdd.allergens, additives: productToAdd.additives, toppings: productToAdd.toppings)
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
    
    func addProductController(productToAdd: Product, imageToAdd: UIImage, modelToAdd: URL)    {
        uploadImageProduct(image: imageToAdd, productToAdd: productToAdd, model: modelToAdd)
    }
    
    func uploadImageProduct(image:UIImage, productToAdd:Product, model: URL) {
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storage.reference().child("ProductImages/\(productToAdd.name)").putData(imageData, metadata: metadata){
                (_, err) in
                if let err = err {
                    print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                } else {
                    print("Bild wurde erfolgreich hochgeladen!")
                    self.uploadModel(localURL: model, productToAdd: productToAdd)
//                    self.getImagePathProduct(productToAdd: productToAdd)
                    
                }
            }
        } else {
            print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
        }
    }
    
    //Image zum Produkt hinzufügen
    func uploadModel(localURL: URL, productToAdd: Product){
        
        guard localURL.startAccessingSecurityScopedResource(),
                  let data = try? Data(contentsOf: localURL) else { return }
            localURL.stopAccessingSecurityScopedResource()
        
        let storageRef = Storage.storage().reference()
        
        let metadata = StorageMetadata()
        metadata.contentType = "model/vnd.usdz+zip"

        let riversRef = storageRef.child("3DModels/\(productToAdd.name).usdz")

        let uploadTask = riversRef.putData(data, metadata: metadata) { (metadata, error) in
            if let error = error{
                print("Error: Modell konnte nicht hochgeladen werden!\(error.localizedDescription)")
            }
            else {
              print("Modell wurde erfolgreich hochgeladen!")
                self.getImagePathProduct(productToAdd: productToAdd)
          }
         
//            riversRef.downloadURL { (url, error) in
//            guard let downloadURL = url else {
//                print(error?.localizedDescription)
//              return
//            }
//          }
        }
    }
    
    func getImagePathProduct(productToAdd: Product){
        //Bildpfad ermitteln
        let storageRef = Storage.storage().reference(withPath: "ProductImages/\(productToAdd.name)")
        storageRef.downloadURL(completion: { [self] url, error in
            guard let url = url, error == nil else {
                print("Error: Bildpfad konnte nicht ermittelt werden!")
                return
            }
            //Modellpfad ermitteln
            let imageURL = url.absoluteString
            print("Bildpfad wurde erfolgreich ermittelt!")
            let storageRef = Storage.storage().reference(withPath: "3DModels/\(productToAdd.name).usdz")
            storageRef.downloadURL(completion: { [self] url, error in
                guard let url = url, error == nil else {
                    print("Error: Modellpfad konnte nicht ermittelt werden!")
                    return
                }
                let modelURL = url.absoluteString
                print("Modellpfad wurde erfolgreich ermittelt!")
                addProduct(productToAdd: productToAdd, imagePath: imageURL, modelPath: modelURL)
            }
        )}
        )
        
    }
    
    func addProductController(productToAdd: Product, imageToAdd: UIImage)    {
        uploadImageProduct(image: imageToAdd, productToAdd: productToAdd)
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
        storage.reference().child("ProductImages/\(productToDelete.name)").delete { error in
            if error != nil {
                print("Error: Bild konnte nicht gelöscht werden!")
            } else {
                print("Bild wurde erfolgreich gelöscht!")
            }
        }
        storage.reference().child("3DModels/\(productToDelete.name).usdz").delete { error in
            if error != nil {
                print("Error: Modell konnte nicht gelöscht werden!")
            } else {
                print("Modell wurde erfolgreich gelöscht!")
            }
        }
        
    }
    
    //Image zum Produkt hinzufügen
    
    func uploadImageProduct(image:UIImage, productToAdd:Product) {
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storage.reference().child("ProductImages/\(productToAdd.name)").putData(imageData, metadata: metadata){
                (_, err) in
                if let err = err {
                    print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                } else {
                    print("Bild wurde erfolgreich hochgeladen!")
                    self.getImagePathProduct(productToAdd: productToAdd)
                    
                }
            }
        } else {
            print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
        }
    }
    
    func uploadFile(url: URL) {
            let fileData = url
            let storage = Storage.storage()
            let metadata = StorageMetadata()
            metadata.contentType = "model/vnd.usdz+zip"
        storage.reference().child("3DModels/\(url.lastPathComponent)").putFile(from: fileData, metadata: metadata) { metadata, err in

                if let err = err {
                    print("Error: Datei konnte nicht hochgeladen werden! \(err.localizedDescription)")
                } else {
                    print("Datei wurde erfolgreich hochgeladen!")
                    
                    
                }
            }
         
    }
    
    func getImagePathProduct(productToAdd: Product){
        let storageRef = Storage.storage().reference(withPath: "ProductImages/\(productToAdd.name)")
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
    
    func updateProduct(productToUpdate: Product, isVisible: Bool){
        //Set the data to update
        db.collection("ImHörnken").document("Menu").collection("Products").document(productToUpdate.id ?? "").setData(["isVisible": isVisible] , merge: true) { error in
            
            //Check for Errors
            if error == nil{
                print("Produkt wurde aktualisiert!")
                //Get the new data
                self.fetchProductsData()
            }
            else{
                print("Error: Produkt konnte nicht aktualisiert werden!")
            }
        }
    }
    
   // Alternative zu updateData
        func updateData(productToUpdate: Product) {
            if let documentId = productToUpdate.id {
              do {
                  try db.collection("ImHörnken").document("Menu").collection("Products").document(documentId).setData(from: productToUpdate)
              }
              catch {
                print(error)
              }
            }
          }
    
    private func updateOffer(_ offer: Offer) {
        if let documentId = offer.id {
          do {
              try db.collection("ImHörnken").document("Menu").collection("Offers").document(documentId).setData(from: offer)
          }
          catch {
            print(error)
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
                
                let data = queryDocumentSnapshot.data()

                let products = data["products"] as? [String] ?? []
                
                for product in products {
                    self.db.collection("ImHörnken").document("Menu").collection("Products").document(product).getDocument { document, error in
                        if let error = error{
                            print((error.localizedDescription))
                        }
                        else {
                            if let document = document {
                                do {
                                    self.product = try document.data(as: Product.self) ?? Product(image: "", model: "", name: "", category: Category(name: ""), price: 0, description: "", servingSize: ServingSize(unit: Unit(name: "g"), size: 0), isVegan: false, isBio: false, isFairtrade: false, isVisible: false, nutritionFacts: NutritionFacts(calories: 0, fat: 0, carbs: 0, protein: 0), allergens: [], additives: [], toppings: [])
                                    print(self.product.name + " 1")
                                }
                                catch {
                                    print(error)
                                }
                            }
                            
                    }
                        
                        self.offerProducts.append(self.product)
                        self.fetchOffer(offerProducts: self.offerProducts.removeDuplicates())
                        }
                    }
                return try? queryDocumentSnapshot.data(as: Offer.self)
                }
            }
        print(self.product.name + " Yeah")
        }
    
    func fetchOffer(offerProducts: [Product]){
        db.collection("ImHörnken").document("Menu").collection("Offers").addSnapshotListener { (querySnapshot, error) in
              guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
              }

              self.offers = documents.map { queryDocumentSnapshot -> Offer in
                let data = queryDocumentSnapshot.data()
                let image = data["image"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let products = offerProducts
                  let isVisible = data["isVisible"] as? Bool ?? false

                  return Offer(image: image, title: title, description: description, products: products, isVisible: isVisible)
              }
            }
          }
    
    
    func addOfferController(offerToAdd: Offer, imageToAdd: UIImage)    {
        uploadImageOffer(image: imageToAdd, offerToAdd: offerToAdd)
    }
    
    func addOffer(offerToAdd: Offer, imagePath: String){
        
        let offer = Offer(image: imagePath, title: offerToAdd.title, description: offerToAdd.description, products: offerToAdd.products, isVisible: offerToAdd.isVisible)
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Offers")
        do {
            let newDocReference = try collectionRef.addDocument(from: offer)
            print("Angebot hinzugefügt mit folgender Referenz: \(newDocReference)")
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
        let storage = Storage.storage()
        storage.reference().child("OfferImages/\(offerToDelete.title)").delete { error in
            if error != nil {
                print("Error: Bild konnte nicht gelöscht werden!")
            } else {
                print("Bild wurde erfolgreich gelöscht!")
            }
        }
        
    }
    
    func uploadImageOffer(image: UIImage, offerToAdd: Offer) {
        if let imageData = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storage.reference().child("OfferImages/\(offerToAdd.title)").putData(imageData, metadata: metadata){
                (_, err) in
                if let err = err {
                    print("Error: Bild konnte nicht hochgeladen werden! \(err.localizedDescription)")
                } else {
                    print("Bild wurde erfolgreich hochgeladen!")
                    self.getImagePathOffer(offerToAdd: offerToAdd)
                    
                }
            }
        } else {
            print("Error: Bild konnte nicht entpackt/in Daten umgewandelt werden")
        }
    }
    
    func getImagePathOffer(offerToAdd: Offer){
        let storageRef = Storage.storage().reference(withPath: "OfferImages/\(offerToAdd.title)")
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
    
    func updateOffer(offerToUpdate: Offer, isVisible: Bool){
        //Set the data to update
        db.collection("ImHörnken").document("Menu").collection("Offers").document(offerToUpdate.id ?? "").setData(["isVisible": isVisible] , merge: true) { error in
            
            //Check for Errors
            if error == nil{
                print("Angebot wurde aktualisiert!")
                //Get the new data
                self.fetchOffersData()
            }
            else{
                print("Error: Angebot konnte nicht aktualisiert werden!")
            }
        }
    }
    
    func updateData(offerToUpdate: Offer) {
        if let documentId = offerToUpdate.id {
          do {
              try db.collection("ImHörnken").document("Menu").collection("Offers").document(documentId).setData(from: offerToUpdate)
          }
          catch {
            print(error)
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
    
    //MARK: Unit
    
    func fetchUnitsData() {
        db.collection("ImHörnken").document("Menu").collection("Units").order(by: "name", descending: false).addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error: Units nicht gefunden!")
                return
            }
            
            self.units = documents.compactMap { queryDocumentSnapshot -> Unit? in
                return try? queryDocumentSnapshot.data(as: Unit.self)
                
            }
            
        }
    }
    
    func addUnit(unitToAdd: Unit) {
        let collectionRef = db.collection("ImHörnken").document("Menu").collection("Units")
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
        db.collection("ImHörnken").document("Menu").collection("Units").document(unitToDelete.id ?? "").delete { error in
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
