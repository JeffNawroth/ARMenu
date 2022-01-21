//
//  changePassword.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct changePassword: View {
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var newPassword2 = ""
    @Binding var showingSheet: Bool
    
    
    var disableForm: Bool {
        oldPassword.isEmpty || newPassword.isEmpty || newPassword2.isEmpty || oldPassword != "imHoernken" || newPassword != newPassword2
    }
    
    var body: some View {
        NavigationView{
            Form{
                HStack{
                    Text("Altes")
                        .padding(.trailing, 62)
                    SecureField("Passwort eingeben", text: $oldPassword)
                    
                }
                HStack{
                    Text("Neues")
                        .padding(.trailing, 52)
                    
                    
                    SecureField("Passwort eingeben", text: $newPassword)
                    
                }
                HStack{
                    Text("Bestätigen")
                        .padding(.trailing, 20)
                    
                    SecureField("Passwort wiederholen", text: $newPassword2)
                }
            }
            .navigationBarTitle(Text("Passwort ändern"), displayMode: .inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen"){
                        showingSheet = false
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Ändern"){
                        showingSheet = false
                    }
                    .disabled(disableForm)
                    
                }
                
            }
        }
        
    }
    
    
}

struct changePassword_Previews: PreviewProvider {
    static var previews: some View {
        changePassword(showingSheet: .constant(true))
    }
}

