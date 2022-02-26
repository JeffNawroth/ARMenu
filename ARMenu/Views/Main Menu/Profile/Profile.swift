//
//  Profile.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import FirebaseAuth

struct Profile: View {
    @EnvironmentObject var session: SessionStore
    @State var showingSheet = false
    @State var showingQRSheet = false

    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Benutzername")){
                    Text((Auth.auth().currentUser?.email) ?? "Kunde")
                        .foregroundColor(.gray)
                }
                
                List{

                        Button {
                            showingQRSheet = true
                        } label: {
                            HStack{
                                Image(systemName: "qrcode.viewfinder")
                                Divider()
                                Text("QR-Code verwalten")
                            }
                        }

                        .sheet(isPresented: $showingQRSheet) {
                            QRCodeGenerator(showingSheet: $showingQRSheet )
                        }
                    
                    
                        Button {
                            showingSheet = true
                        } label: {
                            Text("Passwort ändern")
                        }

                        .sheet(isPresented: $showingSheet) {
                            changePassword(showingSheet: $showingSheet )
                        }

                    
               
                        Button {
                            showingSheet = true
                        } label: {
                            Text("E-Mail ändern")
                        }

                        .sheet(isPresented: $showingSheet) {
                            changeEmail(showingSheet: $showingSheet )
                        }
                    }
                
                
                
                Section{
                    HStack{
                        Spacer()
                        Button("Konto löschen"){
                            session.deleteUser()
                        }
                        .foregroundColor(.red)

                        Spacer()
                    }
                }
                
             
                Section{
                    HStack{
                        Spacer()
                        Button("Abmelden"){
                            session.signOut()
                        }
                        .foregroundColor(.red)

                        Spacer()
                    }
                }
                
              

            }
          .navigationBarTitle("Profil")
        }
    }
    
    // Prompt the user to re-provide their sign-in credentials
    
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

