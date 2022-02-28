//
//  Login.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import FirebaseAuth

struct Login: View {
    @EnvironmentObject var session: SessionStore
    @State private var email: String = "speisekarte@imhoernken.de"
    @State private var password: String = "hoernken123"
    @State private var showingRegistrationSheet = false
    @State private var selectedIndex = 0
    @State private var width: CGFloat? = nil
    var loggedInUser = Auth.auth().currentUser


        
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
                 
                    CustomerQRCode()
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
                                signIn()
                            }
                        
                       
                    }
                    
                    Section{
                        Button("Passwort vergessen"){
                            session.resetPassword(email: "litze-eiweiss.0a@icloud.com")
                        }
                    }
                    
                    Section{
                        Button("Neues Konto erstellen"){
                            showingRegistrationSheet = true
                        }
                        .sheet(isPresented: $showingRegistrationSheet) {
                            RegistrationView(showingSheet: $showingRegistrationSheet)
                        }
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
    func signIn(){
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else{
            }
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}





