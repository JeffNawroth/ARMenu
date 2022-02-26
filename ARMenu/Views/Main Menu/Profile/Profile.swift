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
    @State var oldPassword = ""

    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Benutzername")){
                    Text((Auth.auth().currentUser?.email) ?? "Kunde")
                        .foregroundColor(.gray)
                }
                
                Section{
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
                }
                
                
                Section{
                    Button {
                        showingSheet = true
                    } label: {
                        Text("Passwort ändern")
                    }

                    .sheet(isPresented: $showingSheet) {
                        changePassword(showingSheet: $showingSheet )
                    }
                }
                
             
             
                HStack{
                    Spacer()
                    Button("Abmelden"){
                        session.signOut()
                    }
                    .foregroundColor(.red)

                    Spacer()
                }
              
                HStack{
                    Spacer()
                    Button("Konto löschen"){
                        session.deleteUser()
                    }
                    .foregroundColor(.red)

                    Spacer()
                }

               
               

            }
          .navigationBarTitle("Profil")
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

