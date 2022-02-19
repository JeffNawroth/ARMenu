//
//  Login.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import FirebaseAuth

class UserAuthentication: ObservableObject{
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                print("Fehler beim einloggen")
                return
            }
            //Success
            DispatchQueue.main.async {
                self?.signedIn = true
                print("Nutzer eingeloggt")
                print(self?.signedIn ?? "Unbekannt")
            }
        }
    }
    
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else{
                return
            }
            //Success
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut(){
        try? auth.signOut()
        
        self.signedIn = false
    }
    
}

struct Login: View {
    @State var user: User = User()
    @EnvironmentObject var userInfo: UserInfo
    @EnvironmentObject var userModel: UserAuthentication
    @State var email: String = "ec_61@hotmail.de"
    @State var password: String = "test123"
    //    @Binding var signInSucces: Bool
    
//    var body: some View {
//        NavigationView{
//            Form{
//                Section(header: Text("Mit Benutzerkonto Einloggen")){
//                    HStack{
//                        Text("Email-Adresse")
//                            .padding(.trailing)
//                        TextField("Email-Adresse", text:self.$user.email)
//                    }
//                    HStack {
//                        Text("Passwort")
//                            .padding(.trailing, 56)
//
//                        SecureField("Erforderlich", text: $user.password)
//                    }
//
//                    Button("Anmelden"){
//                        self.userInfo.isUserAuthenticated = .signedIn
//                    }
//                    .opacity(user.isLogInComplete ? 1 : 0.75)
//                    .disabled(!user.isLogInComplete)
//
//
//                }
//
//            }
//
//
//            //              CustomerQRCode(signInSuccess: $signInSucces)
//
//        }
//        .navigationTitle("Willkommen!")
//    }
//
//}

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


                    //                        Button("Anmelden"){
                    //                            if email == "ImHoernken" && password == "ImHoernken"{
                    //                                signInSucces = true
                    //
                    //                            }
                    ////                            userModel.signIn(email: email, password: password)
                    //                            }
                    Button("Anmelden"){

                        userModel.signIn(email: email, password: password)
                    }

                    NavigationLink("Registrieren", destination: SignUp())
                }

            }


//                          CustomerQRCode(signInSuccess: $signInSucces)

        }
        .navigationTitle("Willkommen!")
    }

}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        //        Login(signInSucces: .constant(true))
        Login()
    }
}

