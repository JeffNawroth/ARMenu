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
    @State private var showingSheet = false
    @State private var showingQRSheet = false
    @State private var width: CGFloat? = nil
    @State private var showingDeleteConfirmation = false

    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Benutzername")){
                    Text((Auth.auth().currentUser?.email) ?? "Kunde")
                        .foregroundColor(.gray)
                }
                
                
                Section {
                    Button {
                        showingSheet = true
                    } label: {
                        HStack{
                            Image(systemName: "envelope")
                                .frame(width: width, alignment: .leading)
                                .lineLimit(1)
                                .background(WidthPreferenceSettingView())
                               
                            Text("E-Mail ändern")
                                
                            
                        }
                    }
                    
                    .sheet(isPresented: $showingSheet) {
                        changeEmail(showingSheet: $showingSheet )
                    }
                    
                    Button {
                        showingSheet = true
                    } label: {
                        HStack{
                            Image(systemName: "key")
                                .frame(width: width, alignment: .leading)
                                .lineLimit(1)
                                .background(WidthPreferenceSettingView())
                            Text("Passwort ändern")
                                
                        }
                    }
                    
                    .sheet(isPresented: $showingSheet) {
                        changePassword(showingSheet: $showingSheet )
                    }
                    
                } header: {
                    Text("Kontoeinstellungen")
                }
                
                

            Section{
                Button {
                    showingQRSheet = true
                } label: {
                    HStack{
                        Image(systemName: "qrcode")
                            .frame(width: width, alignment: .leading)
                            .lineLimit(1)
                            .background(WidthPreferenceSettingView())
                        Text("QR-Code verwalten")
                    }
                }
                
                .sheet(isPresented: $showingQRSheet) {
                    QRCodeGenerator(showingSheet: $showingQRSheet )
                }
            }
                
                Section{
                    HStack{
                        Spacer()
                        Button {
                            session.signOut()
                        } label: {
                            HStack{
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Abmelden")
                            }
                        }
                        
                        Spacer()
                    }
                }
            
            
            Section{
                
                HStack{
                    Spacer()
                    Button {
                        showingDeleteConfirmation = true
                    } label: {
                        HStack{
                            Image(systemName: "trash")
                            Text("Konto löschen")
                        }

                    }
                    .foregroundColor(.red)
                    .confirmationDialog("Dieses Konto mit sämtlichen Daten unwiderruflich löschen?", isPresented: $showingDeleteConfirmation, titleVisibility: .visible) {
                        Button("Löschen", role: .destructive){
                            session.deleteUser()
                        }
                    }
                    Spacer()
                    
                }
                

                    
            }
            
                
            
           
        }
        .navigationBarTitle("Profil")
            // Create Textfield Spacing
        .onPreferenceChange(WidthPreferenceKey.self) { preferences in
                    for p in preferences {
                        let oldWidth = self.width ?? CGFloat.zero
                        if p.width > oldWidth {
                            self.width = p.width
                        }
                    }
                }
    }
}

}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

