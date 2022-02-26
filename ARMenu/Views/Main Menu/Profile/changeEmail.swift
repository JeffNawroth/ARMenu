//
//  changeEmail.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 26.02.22.
//

import SwiftUI

struct changeEmail: View {
    @EnvironmentObject var session: SessionStore
    @State var newEmail = ""
    @State var newEmail2 = ""
    @Binding var showingSheet: Bool
    @State private var width: CGFloat? = nil
        

    var disableForm: Bool {
        newEmail.isEmpty || newEmail2.isEmpty || newEmail != newEmail2
    }
    var body: some View {
        NavigationView{
            Form{
                HStack{
                    Text("Neues")
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(WidthPreferenceSettingView())
                    
                    TextField("E-Mail eingeben", text: $newEmail)
                    
                }
               
                HStack{
                    Text("Bestätigen")
                        .frame(width: width, alignment: .leading)
                        .lineLimit(1)
                        .background(WidthPreferenceSettingView())
                    
                    TextField("E-Mail wiederholen", text: $newEmail2)
                }
            }
            .navigationBarTitle(Text("E-Mail ändern"), displayMode: .inline)
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
                        session.updateEmail(email: newEmail)
                        session.signOut()
                        showingSheet = false
                        
                    }
                    .disabled(disableForm)
                    
                }
                
            }
        }
    }
}

struct changeEmail_Previews: PreviewProvider {
    static var previews: some View {
        changeEmail(showingSheet: .constant(true))
    }
}
