//
//  CustomerQRCode.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 09.02.22.
//

import SwiftUI
import CodeScanner
import FirebaseFirestore

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
                        .font(.system(size: 250))
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
    
    //Handle Scan of QR-Code
    func handleScan(result: Result<ScanResult, ScanError>){
        isShowingScanner = false
        
        switch result{
        case .success(let result):
            print (result.string)
            
            //detect URLs inside the result
            let input = result.string
            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))
            
            //Check if there is no url in the result, otherwise it will be recognized as a path
            if matches.isEmpty{
                let db = Firestore.firestore()
                db.collection(result.string).getDocuments { (querysnapshot, error) in
                    if error != nil {
                        print("Error: QR-Code führt zu keiner Speisekarte", error!)
                    } else {
                        if let doc = querysnapshot?.documents, !doc.isEmpty {
                            print("Speisekarte existiert!")
                            
                            session.signInAnonymous(result: result.string)
                        }else{
                            print("Speisekarte existiert nicht!")
                        }
                    }
                }
            }else{
                print("Speisekarte existiert nicht!")
                
                
                
            }
            
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
    
    func documentExists(docId: String){
        let db = Firestore.firestore()
        db.collection(docId).getDocuments { (querysnapshot, error) in
            if error != nil {
                print("Error: QR-Code führt zu keiner Speisekarte", error!)
            } else {
                if let doc = querysnapshot?.documents, !doc.isEmpty {
                    print("Speisekarte existiert!")
                }
            }
        }
    }
    
    
    
}

struct CustomerQRCode_Previews: PreviewProvider {
    static var previews: some View {
        CustomerQRCode()
    }
}
