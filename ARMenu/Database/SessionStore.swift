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
    // Handler for listening to changes in the authentication state.
    var handle: AuthStateDidChangeListenerHandle?
    // The current user who is logged in.
    let user = Auth.auth().currentUser

    
    
    func listen(){
        // Monitor authentication changes using Firebase
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            // Check if there is a user
            if let user = user{
                // Check if user is not anonymous
                if !user.isAnonymous{
                    // Create user with the userID and user amil.
                    self.loggedInUser = User(uid: user.uid, email: user.email)
                }

            } else {
                // No user logged in. Set session to nil.
                self.loggedInUser = nil
            }
        })
    }
    
    func signInAnonymous(result: String){
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return }
            _ = user.isAnonymous  // true
            _ = user.uid
            print(user.uid)
            self.loggedInUser = User(uid: result)
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
            // Check if the current user is not anonymous.
            if !Auth.auth().currentUser!.isAnonymous{
                // User is not anonymous. Sign out and set session to nil.
            try Auth.auth().signOut()
            self.loggedInUser = nil
            print("Benutzer wurde erfolgreich ausgeloggt!")
        }else{
            // User is anonymous. Set session to nil and delete the user to avoid multiple anonymous accounts in the database.
            self.loggedInUser = nil
            self.deleteUser()
        }
            
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
            }
        })
    }
    
    func resetPassword(email: String){
    Auth.auth().sendPasswordReset(withEmail: email) { error in
        if error != nil{
            print("Error: Fehler beim Zurücksetzen des Passwortes!")
        }
        else{
            print("Passwort wurde erfolgreich zurückgesetzt!")
        }
    }}
    
    func sendEmailVerification(){
        Auth.auth().currentUser?.sendEmailVerification { error in
            if error != nil{
                print("Error: Fehler beim senden der Verifikation!")
            }
            else{
                print("Email-Verifikation erfolgreich gesendet!")
            }
        }
    }
    
    deinit{
        unbind()
    }
    
}
