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
    var loggedInUser: User = ModelData().users[0]
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Benutzername")){
                    Text(loggedInUser.username!)
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

