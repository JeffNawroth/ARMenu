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
    @State var signInSucces = false
    
    var body: some View {
//        if userModel.isSignedIn{
//            MainView()
//                .environmentObject(ModelData())
//        }
//        else{
//            Login()
//        }
        if signInSucces{
            MainView()
                .environmentObject(ModelData())


        }else{
            Login(signInSucces: $signInSucces)
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

