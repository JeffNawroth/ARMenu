//
//  Login.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
    @EnvironmentObject var userModel: UserAuthentication
    @State var email: String = "ec_61@hotmail.de"
    @State var password: String = "imhörnken123"
//    @Binding var signInSucces: Bool
    
        
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
                            userModel.signIn(email: email, password: password)
                            }
                        }
                    
                }
                
                
                Section(header: Text("Oder für kunden")){
                    Button {
                    } label: {
                        HStack{
                            Image(systemName: "qrcode.viewfinder")
                            Divider()
                            Text("QR-Code scannen")
                        }
                        
                    }

                }
                
            }
            .navigationTitle("Willkommen!")
        }
        
    }
    
    
    

struct Login_Previews: PreviewProvider {
    static var previews: some View {
//        Login(signInSucces: .constant(true))
        Login()
    }
}

