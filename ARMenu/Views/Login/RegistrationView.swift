//
//  RegistrationView.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 17.02.22.
//

import SwiftUI

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @Binding var showingSheet: Bool

    var body: some View {
        NavigationView{
            Form{
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
                        
            }
            .navigationTitle("Registrieren")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSheet = false
                    } label: {
                        Text("Abbrechen")
                    }

                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = false
                    } label: {
                        Text("Fertig")
                    }
                }
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(showingSheet: .constant(true))
    }
}
