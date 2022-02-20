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
    @State private var width: CGFloat? = nil
    
    
    
    var disableForm: Bool {
        oldPassword.isEmpty || newPassword.isEmpty || newPassword2.isEmpty || oldPassword != "imHoernken" || newPassword != newPassword2
    }
    
    var body: some View {
        NavigationView{
            Form{
                HStack{
                    Text("Altes")
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(WidthPreferenceSettingView())
                    SecureField("Passwort eingeben", text: $oldPassword)
                    
                }
                HStack{
                    Text("Neues")
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(WidthPreferenceSettingView())
                    
                    SecureField("Passwort eingeben", text: $newPassword)
                    
                }
                HStack{
                    Text("Bestätigen")
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(WidthPreferenceSettingView())
                    
                    SecureField("Passwort wiederholen", text: $newPassword2)
                }
            }
            .navigationBarTitle(Text("Passwort ändern"), displayMode: .inline)
            .onPreferenceChange(WidthPreferenceKey.self) { preferences in
                        for p in preferences {
                            let oldWidth = self.width ?? CGFloat.zero
                            if p.width > oldWidth {
                                self.width = p.width
                            }
                        }
                    }
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

