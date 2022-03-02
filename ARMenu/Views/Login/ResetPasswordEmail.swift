//
//  ResetPasswordEmail.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 28.02.22.
//

import SwiftUI

struct ResetPasswordEmail: View {
    @State private var email = ""
    @Binding var showingSheet: Bool
    @EnvironmentObject var session: SessionStore

    var body: some View {
        NavigationView{
            Form{
                Section {
                    HStack{
                        Text("E-Mail")
                        TextField("E-Mail ", text: $email)
                    }

                } header: {
                    Text("Mit E-Mail zurücksetzen")
                }

            }
            .navigationTitle("Passwort vergessen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("Fertig"){
                        session.resetPassword(email: email)

                        showingSheet = false
                    }
                    .disabled(email.isEmpty)
                })
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                        showingSheet = false
                    }
                }
            }
        }
        
    }
}

struct ResetPasswordEmail_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordEmail(showingSheet: .constant(true))
    }
}
