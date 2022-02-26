//
//  Login.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import FirebaseAuth

//class UserAuthentication: ObservableObject{
//
//    let auth = Auth.auth()
//
//    @Published var signedIn = false
//
//    var isSignedIn: Bool{
//        return auth.currentUser != nil
//    }
//
//    func signIn(email: String, password: String){
//        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
//            guard result != nil, error == nil else{
//                print("Fehler beim einloggen")
//                return
//            }
//            //Success
//            DispatchQueue.main.async {
//                self?.signedIn = true
//                print("Nutzer eingeloggt")
//                print(self?.signedIn ?? "Unbekannt")
//            }
//        }
//    }
//
//    func signUp(email: String, password: String){
//        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
//            guard result != nil, error == nil else{
//                return
//            }
//            //Success
//            DispatchQueue.main.async {
//                self?.signedIn = true
//            }
//        }
//    }
//
//    func signOut(){
//        try? auth.signOut()
//
//        self.signedIn = false
//    }
//
//}

struct Login: View {

    @EnvironmentObject var session: SessionStore
    @State var email: String = "speisekarte@imhoernken.de"
    @State var password: String = "imhoernken"
    @State var error: String = ""


    func signIn(){
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
            } else{
                self.email = ""
                self.password = ""
            }
        }
    }
    

    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Mit Benutzerkonto Einloggen")){
                    HStack{
                        Text("Email-Adresse")
                            .padding(.trailing)
                        TextField("Email-Adresse", text:$email)
                    }
                    HStack {
                        Text("Passwort")
                            .padding(.trailing, 56)

                        SecureField("Erforderlich", text: $password)
                    }

                    Button("Anmelden"){
                        signIn()
                        
                    }
                    NavigationLink("Registrieren", destination: SignUp())

                    Button("Anonym anmelden"){
                        session.signInAnonymous()
                    }
                }
                CustomerQRCode()
            }


               

        }
        .navigationTitle("Willkommen!")
    }

}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

