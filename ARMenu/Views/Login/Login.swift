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
    
    var dummyUser = User.dummyUser
    
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
                            if(username == dummyUser.username && password == dummyUser.password){
                                signInSucces = true

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
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(signInSucces: .constant(true))
    }
}

