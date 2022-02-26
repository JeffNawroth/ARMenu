//
//  CustomerQRCode.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 09.02.22.
//

import SwiftUI
import CodeScanner
import FirebaseAuth

struct CustomerQRCode: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var session: SessionStore
//    @Binding var signInSuccess: Bool
    @State private var isShowingScanner = false
    var body: some View {
        Section(header: Text("Oder für kunden")){
            Button {
                isShowingScanner = true
            } label: {
                HStack{
                    Image(systemName: "qrcode.viewfinder")
                    Divider()
                    Text("QR-Code scannen")
                }
                
            }

        }
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
            print ((result.string))
            modelData.qrCodeResult = result.string
            session.signInAnonymous()
            session.loggedInUser?.uid = result.string
            
//            if(result.string == "imHoernken"){
//                signInSuccess = true
//            }
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
