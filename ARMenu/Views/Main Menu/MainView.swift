//
//  MainView.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var productModelData: ModelData

    var body: some View {
        TabView {
            
            AboutUs()
                .tabItem {
                    Label("Über uns", systemImage: "house")
                }

            
            MenuList()
                .tabItem {
                    Label("Speisekarte", systemImage: "list.dash")
                }
               


                Profile()
                    .tabItem {
                        Label("Profil", systemImage: "person.fill")
                    }
        }

        //.accentColor(Color(red: 120/255, green: 172/255, blue: 149/255))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ModelData())
    }
}

