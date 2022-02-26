//
//  SessionStore.swift
//  ARMenu
//
//  Created by Eren Cicek on 25.02.22.
//

import Foundation
import Firebase
import Combine

class SessionStore: ObservableObject{
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var loggedInUser: User? {didSet {self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?
//    @Published var user: User = .init(restaurant: "", uid: "", email: "")
//    @Published var guest: Bool = false
//    @Published var loggedInUser = User()
    
    
    func listen(){
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user{
                if !user.isAnonymous{
//                    self.loggedInUser.uid
//                    self.sess.uid = user.uid
//                    self.loggedInUser.email = user.email
//                    self.loggedInUser.userRole = .admin
                    self.loggedInUser = User(uid: user.uid, email: user.email, userRole: .admin)
                }
                
                
//                else{
////                    self.session = User(restaurant: "",uid: user.uid, email: user.email!)
//                    let db = Firestore.firestore()
//                    db.collection("User").document(user.uid).getDocument { doc, error in
//                        if error != nil{
//                            print("Error: Fehler beim empfangen des Benutzers!")
////                        } else{
//    //                        let data = doc?.data()
//    //                        print("Der Benutzer wurde erfolgreich empfangen!")
//    ////                        self.session = User(data: data!)!
//    //                        self.session = User(restaurant: "",uid: user.uid, email: user.email!)
//    ////                        self.user = User(data: data!)!
//    //                        print(self.session!.email)
//    //                        print(self.session!.uid)
//    //                        print(self.session!.restaurant)
//    //                        return
//                        }
//
//                    }
//
////
//                }
            } else {
                self.loggedInUser = nil
            }
        })
    }
    
    func signInAnonymous(){
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return }
            _ = user.isAnonymous  // true
            _ = user.uid
            print(user.uid)
            self.loggedInUser = User(userRole: .customer)
        }
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
//    func createUserInfo(restaurant: String){
//        let db = Firestore.firestore()
//        let email = Auth.auth().currentUser?.email
//        let userID = Auth.auth().currentUser?.uid
//        let data = ["restaurant": restaurant, "email": email, "userID": userID]
//
//        user = User(restaurant: restaurant, uid: userID!, email: email!)
//
////        db.collection(restaurant).document("User").collection("Admin").document("\(userID!)").setData(["restaurant": restaurant ,"userEmail": email!, "userID": userID!])
//        db.collection("User").document("\(userID!)").setData(data as [String : Any], merge: true) { error in
//            if error != nil{
//                print("Error: Fehler beim Erstellen des Benutzers!")
//            } else{
//                print("Benutzer wurde erfolgreich zur Datenbank hinzugefügt")
//                self.getUser(uid: userID!)
//            }
//        }
//    }
    
    func signIn(email: String, password: String, handler: @escaping AuthDataResultCallback){
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut()
            self.loggedInUser = nil
        } catch {
            print("Error: Fehler beim Ausloggen!")
        }
    }
    
    func unbind(){
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func updateEmail(email: String){
    Auth.auth().currentUser?.updateEmail(to: email) { error in
        if error != nil{
            print("Error: Fehler beim aktualisieren der Email!")
        } else{
            print("Email erfolgreich aktualisiert!")
        }
    }}
    
    func updatePassword(password: String){
    Auth.auth().currentUser?.updatePassword(to: password) { error in
        if error != nil{
            print("Error: Passwort konnte nicht aktualisiert werden")
        } else{
            print("Passwort wurde erfolgreich aktualisiert!")
        }
    }}
    
    func deleteUser(){
        let user = Auth.auth().currentUser
        user?.delete(completion: { error in
            if error != nil{
                print("Error: Fehler beim Löschen des Benutzers!")
            }else{
                print("Benutzer wurde erfolgreich gelöscht!")
                let db = Firestore.firestore()
                db.collection("User").document(user!.uid).delete { error in
                    if error != nil{
                        print("Error: Benutzer konnte nicht aus der Datenbank gelöscht werden!")
                    }
                }
            }
        })
    }
    
//    func getUser(uid: String){
//        let db = Firestore.firestore()
//        db.collection("User").document(uid).getDocument { doc, error in
//            if error != nil{
//                print("Error: Fehler beim empfangen des Benutzers!")
//            } else{
//                let data = doc?.data()
//                print("Der Benutzer wurde erfolgreich empfangen!")
//                self.session = User(data: data!)!
//                print(self.session!.email)
//                print(self.session!.uid)
//                print(self.session!.restaurant)
//                return
//            }
//        }
//    }
    
    deinit{
        unbind()
    }
    
}
