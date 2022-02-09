//
//  Login.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct Login: View {
    @State var username: String = "imHoernken"
    @State var password: String = "imHoernken"
    @Binding var signInSucces: Bool
        
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Mit Benutzerkonto Einloggen")){
                    HStack{
                        Text("Benutzername")
                            .padding(.trailing)
                        TextField("Benutzername", text:$username)
                    }
                    HStack {
                        Text("Passwort")
                            .padding(.trailing, 56)

                        SecureField("Erforderlich", text: $password)
                    }
                        
                    
                        Button("Anmelden"){
                            if(username == "imHoernken" && password == "imHoernken"){
                                signInSucces = true

                            }
                        }
                    
                }
                
                
              CustomerQRCode()
                
            }
            .navigationTitle("Willkommen!")
        }
        
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(signInSucces: .constant(true))
    }
}

