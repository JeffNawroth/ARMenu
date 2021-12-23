//
//  ContentView.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    
    var modelData: ModelData = ModelData()
    @State var signInSucces = false
    var body: some View {
        if signInSucces{
            MainView(modelData: modelData)
            
        }else{
            Login(signInSucces: $signInSucces)
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(modelData:ModelData())
    }
}
#endif

