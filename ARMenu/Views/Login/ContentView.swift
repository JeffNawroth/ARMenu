//
//  ContentView.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    @EnvironmentObject var session: SessionStore
    var body: some View {
        Group{
            if session.loggedInUser != nil{
                MainView()
                    .environmentObject(ModelData(menuId: (session.loggedInUser?.uid)!))
                    
            }else{
                Login()
            }
        }
        .onAppear(perform: getUser)
      
    }
    
    func getUser(){
        session.listen()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

