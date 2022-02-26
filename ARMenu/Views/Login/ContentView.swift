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

    @EnvironmentObject var session: SessionStore

    
    func getUser () {
          session.listen()
      }
    var body: some View {
        Group{
            if session.loggedInUser != nil{
            MainView()
//                .environmentObject(ModelData())
        }
        else{
            Login()
//                .environmentObject(SessionStore())
        }
        }.onAppear(perform: getUser)
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(SessionStore())
    }
}
#endif

