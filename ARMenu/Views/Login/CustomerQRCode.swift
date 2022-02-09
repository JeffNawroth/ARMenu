//
//  CustomerQRCode.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 09.02.22.
//

import SwiftUI
import CodeScanner

struct CustomerQRCode: View {
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
            print (result.string)
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
