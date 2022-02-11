//
//  Login.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
    
    @State var email: String = "ImHoernken"
    @State var password: String = "ImHoernken"
    @Binding var signInSucces: Bool
    
        
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
                        
                    
                        Button("Anmelden"){
                            if email == "ImHoernken" && password == "ImHoernken"{
                                signInSucces = true

                            }
//                            userModel.signIn(email: email, password: password)
                            }
                        }
                    
                }
                
                
//              CustomerQRCode(signInSuccess: $signInSucces)
                
            }
            .navigationTitle("Willkommen!")
        }
        
    }
    
    
    

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(signInSucces: .constant(true))
//        Login()
    }
}

