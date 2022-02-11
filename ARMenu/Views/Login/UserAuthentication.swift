//
//  UserAuthentication.swift
//  ARMenu
//
//  Created by Eren Cicek on 11.02.22.
//

import Foundation
import FirebaseAuth
import SwiftUI

class UserAuthentication: ObservableObject{
    
    let auth = Auth.auth()
    @Published var signedIn = false
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                print("Erfolgreich eingeloggt!")
                return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else{
                print("Erfolgreich registriert!")
                return
            }
//            if result != nil, error == nil{
//                print("Erfolgreich registriert!")
//                return
//            }
//            else{
//                print("Error: Fehler beim Einloggen!")
//                print(error?.localizedDescription ?? "")
//            }
        }
    }
}
