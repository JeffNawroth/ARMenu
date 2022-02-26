//
//  SessionStore.swift
//  ARMenu
//
//  Created by Eren Cicek on 25.02.22.
//

import Foundation
import Firebase
import Combine
import FirebaseAuth

class SessionStore: ObservableObject{
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var loggedInUser: User? {didSet {self.didChange.send(self) }}
    var handle: AuthStateDidChangeListenerHandle?

    
    
    func listen(){
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user{
                if !user.isAnonymous{

                    self.loggedInUser = User(uid: user.uid, email: user.email, userRole: .admin)
                }

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
    
    deinit{
        unbind()
    }
    
}
