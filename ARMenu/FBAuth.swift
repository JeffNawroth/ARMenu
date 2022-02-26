//
//  FBAuth.swift
//  ARMenu
//
//  Created by Eren Cicek on 23.02.22.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct FBAuth {
    
    static func authenticate(withEmail email: String,
                                 password: String,
                                 completionHandler: @escaping (Result<Bool, EmailAuthError>) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
                // check the NSError code and convert the error to an AuthError type
                
                if let err = error {
                    print("Error: Fehler beim Einloggen!")
                    completionHandler(.failure(authError!))
                } else {
                    completionHandler(.success(true))
                }
            }
        }
    
    static func createUser(withEmail email: String,
                               name: String,
                               password: String,
                               completionHandler: @escaping (Result<Bool, Error>) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let err = error {
                    completionHandler(.failure(err))
                    return
                }
                guard authResult?.user != nil else {
                    completionHandler(.failure(error!))
                    return
                }
                let user = FBUser(uid: authResult!.user.uid, name: name, email: authResult!.user.email!)
                FBFirestore.mergeFBUser(fbUser: user, uid: authResult!.user.uid) { result in
                    completionHandler(result)
                }
                completionHandler(.success(true))
            }
        }
    // MARK: - Logout
        /// Function called when a log out call is made.  Sets the FBAuthSate to .signout
        /// - Parameter completion: completion handler for result
        public static func logout(completion: @escaping (Result<Bool, Error>) -> Void) {
            let auth = Auth.auth()
            do {
                try auth.signOut()
                completion(.success(true))
            } catch let err {
                completion(.failure(err))
            }
        }
}
