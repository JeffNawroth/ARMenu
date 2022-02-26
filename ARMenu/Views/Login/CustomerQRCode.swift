//
//  CustomerQRCode.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 09.02.22.
//

import SwiftUI
import CodeScanner

struct CustomerQRCode: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var session: SessionStore
    @State private var isShowingScanner = false

    var body: some View {
        Section(){

            Button {
                isShowingScanner = true
            } label: {
                VStack{
                    Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 240))
                    Text("QR-Code scannen")
                }
                

            }
            .listRowBackground(Color.clear)
            .buttonStyle(.borderless)
            .foregroundColor(.primary)
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr], completion:handleScan)
                .overlay(ScanOverlayView())
                .ignoresSafeArea()
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>){
        isShowingScanner = false
        
        switch result{
        case .success(let result):
            print (result.string)
            
            modelData.qrCodeResult = result.string
            session.signInAnonymous()
            session.loggedInUser?.uid = result.string
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
    
}

struct CustomerQRCode_Previews: PreviewProvider {
    static var previews: some View {
        CustomerQRCode()
    }
}
