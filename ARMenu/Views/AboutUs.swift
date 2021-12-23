//
//  AboutUs.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI

struct AboutUs: View {
    var body: some View {
        
        ScrollView {
            Image("slider1")
                .resizable()
                .scaledToFit()
                .overlay(Rectangle().frame(width: nil, height: 20).foregroundColor(Color(red: 120/255, green: 172/255, blue: 149/255)), alignment: .bottom)
                .overlay(Image("logo").resizable().scaledToFit().frame(width: 250))
                .ignoresSafeArea()
            
            VStack{
                Text("Hömma - Herzlich Willkommen im Hörnken")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("EuphoriaScript-Regular", size: 25))
                    .padding(.top)

                Text("**DU** suchst einen Ort zum Wohlfühlen? Wir, das Team vom Hörnken, wollen einen Ort schaffen, wo **Du** gerne hinkommst. Egal, ob **Du** Dich **betüddeln** lassen möchtest, einfach mal mit Deinen Freunden in Ruhe **schnacken** oder **Spökes** machen magst. Ob Schmacht oder Brand, wir haben für Dich die Lösung. ")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .bottom, .trailing])
                
                Text("Das Hörnken soll ein Ort zum Entspannen sein, deshalb duzen wir uns. Und egal wen du ansprichst, wir sind stets mit einem Lächeln da und versüßen dir den Tag.")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding([.top, .leading, .trailing])
                
                
                Text("Öffnungszeiten")
                    .font(Font.custom("EuphoriaScript-Regular", size: 25))
                    .padding(.top)
                
                Text("Montag bis Donnerstag: 11:30 Uhr bis 18.00 Uhr\nFreitag: Machen wir frei - Ruhetag!\nSamstag: 13:00 Uhr bis 18:00 Uhr\nSonntag: 11:30 Uhr bis 18:00 Uhr")
                    .multilineTextAlignment(.center)
                
                    

            }
            
            Spacer()
            
            
            Text("Im Sommer sind wir auch länger für euch da!")
            Spacer()
            Text("Tel: 02721/7190236")
            
            Spacer()
            
            HStack {
                VStack{
                    Link(destination: URL(string: "https://www.instagram.com/imhoernken/")!) {
                        VStack{
                            Image("instagram")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            
                            Text("Im Hoernken")
                            
                        }
                    }
                    .padding()
                    Link(destination: URL(string: "https://www.facebook.com/imHoernken")!) {
                        VStack{
                            Image("facebook")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            
                            Text("Im Hörnken")
                            
                        }
                    }
                    .padding()
                }
                
                VStack{
                    Link(destination: URL(string: "https://www.instagram.com/hoernken.to.go/")!) {
                        VStack{
                            Image("instagram")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            
                            Text("Hoernken.to.go")
                        }
                    }
                    .padding()

                    Link(destination: URL(string: "https://www.im-hoernken.de/")!) {
                        VStack{
                            Image(systemName: "globe")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80)
                            
                            Text("Website")
                               
                        }
                    }
                    .padding()
                }
                
                
            }
            
            
            Link(destination: URL(string: "https://www.im-hoernken.de/onlineshop/")!) {
                VStack{
                    Image("onlineshop")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110)
                    
                    Text("Onlineshop")
                       
                }
            }
                    
            
        }.edgesIgnoringSafeArea(.top)
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}
