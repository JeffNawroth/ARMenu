//
//  Profile.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct Profile: View {
    @State var showingSheet = false
    @State var oldPassword = ""
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Benutzername")){
                    Text("imHoernken")
                        .foregroundColor(.gray)
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
                
                Section{
                    Button {
//                        showingSheet = true
                        //TODO: create sheet for QR-Code
                    } label: {
                        Text("QR-Code verwalten")
                    }

                    .sheet(isPresented: $showingSheet) {
                        changePassword(showingSheet: $showingSheet )
                    }
                }
             
                HStack{
                    Spacer()
                    Button("Abmelden"){
                        
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

