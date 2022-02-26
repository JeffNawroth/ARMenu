//
//  SignUp.swift
//  ARMenu
//
//  Created by Eren Cicek on 24.02.22.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUp: View {
    
    @State var error: String = ""
    @State var restaurant: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var session: SessionStore
    
    func signUp(){
        session.signUp(email: email, password: password) { (result, error) in
            if let error = error{
                self.error = error.localizedDescription
            } else{
//                session.createUserInfo(restaurant: restaurant)
            }
        }
    }
    
    var body: some View {

        NavigationView{
            Form{
                Section(header: Text("Mit Benutzerkonto Einloggen")){
                
                    HStack{
                        Text("Email-Adresse")
                            .padding(.trailing)
                        TextField("Email-Adresse", text:$email)
                    }
                    HStack {
                        Text("Passwort")
                            .padding(.trailing, 56)

                        SecureField("Erforderlich", text: $password)
                    }
                    
                    Button(action: signUp){
                        Text("Registrieren")
                    }

                }

            }

        }
        .navigationTitle("Registrieren!")
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
