//
//  Login.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct Login: View {
    @State private var username: String = "imHoernken"
    @State private var password: String = "imHoernken"
    @Binding  var signInSucces: Bool
    @State private var showingRegistrationSheet = false
    @State private var selectedIndex = 0

        
    var body: some View {
        NavigationView{
            
            Form{
                Picker("Favorite Color", selection: $selectedIndex, content: {
                               Text("Kunde").tag(0)
                               Text("Konto").tag(1)
                           })
                           .pickerStyle(SegmentedPickerStyle())
                           .listRowBackground(Color.clear)
                
                if selectedIndex == 0{
                 
                    CustomerQRCode(signInSuccess: $signInSucces)
                        .padding(.top, 90)

                }else{
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
                    
                    Button("Neues Benutzerkonto erstellen"){
                        showingRegistrationSheet = true
                    }
                    .sheet(isPresented: $showingRegistrationSheet) {
                        RegistrationView(showingSheet: $showingRegistrationSheet)
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

