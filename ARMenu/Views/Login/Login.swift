//
//  Login.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct Login: View {
    @State private var email: String = "imHoernken"
    @State private var password: String = "imHoernken"
    @Binding  var signInSucces: Bool
    @State private var showingRegistrationSheet = false
    @State private var selectedIndex = 0
    @State private var width: CGFloat? = nil


        
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
                            Text("E-Mail")
                                .frame(width: width, alignment: .leading)
                                .lineLimit(1)
                                .background(WidthPreferenceSettingView())
                            TextField("E-Mail", text:$email)
                        }
                        HStack {
                            Text("Passwort")
                                .frame(width: width, alignment: .leading)
                                .lineLimit(1)
                                .background(WidthPreferenceSettingView())

                            SecureField("Erforderlich", text: $password)
                        }
                            
                        
                            Button("Anmelden"){
                                if(email == "imHoernken" && password == "imHoernken"){
                                    signInSucces = true

                                }
                            }
                    }
                    
                    Button("Neues Konto erstellen"){
                        showingRegistrationSheet = true
                    }
                    .sheet(isPresented: $showingRegistrationSheet) {
                        RegistrationView(showingSheet: $showingRegistrationSheet)
                    }
                }
                
                
                
                
                
            }
            .onPreferenceChange(WidthPreferenceKey.self) { preferences in
                        for p in preferences {
                            let oldWidth = self.width ?? CGFloat.zero
                            if p.width > oldWidth {
                                self.width = p.width
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





