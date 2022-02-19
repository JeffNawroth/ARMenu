//
//  ContentView.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import RealityKit
import FirebaseAuth

struct ContentView : View {
    @EnvironmentObject var userModel: UserAuthentication
    @EnvironmentObject var userInfo: UserInfo
    @State var signInSucces = false
    
    //UserInfo - Stewart Lynch
//    var body: some View {
//        Group{
//        if userInfo.isUserAuthenticated == .undefined{
//            Login()
//        }
//        else if userInfo.isUserAuthenticated == .signedOut{
//            Login()
//        }
//        else if userInfo.isUserAuthenticated == .signedIn{
//            MainView()
//                .environmentObject(ModelData())
//        }
//        }.onAppear{
//            self.userInfo.configureStateDidChange()
//        }
//
//}
//}
//IOS ACADEMY - UserAuthentication
    var body: some View {
        NavigationView{

        if userModel.signedIn{
            MainView()
                .environmentObject(ModelData())
        }
        else{
            Login()
                .environmentObject(UserAuthentication())
        }
//        if userModel.isSignedIn{
//            MainView()
//                .environmentObject(ModelData())
//        }
//        else{
//            Login()
//        }
//        if signInSucces{
//            MainView()
//                .environmentObject(ModelData())
//
//
//        }else{
//            Login(signInSucces: $signInSucces)
//        }
        }.onAppear{
            userModel.signedIn = userModel.isSignedIn
        }
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

