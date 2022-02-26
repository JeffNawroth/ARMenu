//
//  RegistrationView.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 17.02.22.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var password2: String = ""
    @Binding var showingSheet: Bool
    @State private var width: CGFloat? = nil
    var disableForm: Bool {
        password.isEmpty || password2.isEmpty || email.isEmpty || password != password2
    }
    
    var body: some View {
        NavigationView{
            Form{
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
                    SecureField("Passwort", text: $password)
                    
                }
                HStack {
                    Text("Bestätigen")
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(WidthPreferenceSettingView())
                    SecureField("Passwort wiederholen", text: $password2)
                    
                }
                
            }
            .navigationTitle("Registrieren")
            .navigationBarTitleDisplayMode(.inline)
            .onPreferenceChange(WidthPreferenceKey.self) { preferences in
                        for p in preferences {
                            let oldWidth = self.width ?? CGFloat.zero
                            if p.width > oldWidth {
                                self.width = p.width
                            }
                        }
                    }
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
                    .disabled(disableForm)
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
