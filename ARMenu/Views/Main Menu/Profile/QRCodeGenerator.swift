//
//  GenerateQRCode.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 09.02.22.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import FirebaseAuth

struct QRCodeGenerator: View {
    
    
    @State private var name = Auth.auth().currentUser?.uid
    @State private var showingShareSheet = false
    var qrCode: UIImage{
        generateQRCode(from: name!)
    }
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @Binding var showingSheet: Bool
    
    var body: some View {
        NavigationView{
            VStack{
                Image(uiImage: qrCode)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .padding()
            }
            .navigationTitle("QR-Code verwalten ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                        
                    }
                    .sheet(isPresented: $showingShareSheet) {
                        ShareSheet(image: qrCode.resized(toWidth: 512) ?? UIImage())
                            .ignoresSafeArea()
                    }
                    
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSheet = false
                    } label: {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                    }
                    
                }
                
                
                
                
            }
            
        }
        
    }
    
//    func actionSheet(image: UIImage) {
//        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
//        UIApplication.shared.keyWindow?.rootViewController?
//            .present(activityVC, animated: true, completion: nil)
//    }
    
    func generateQRCode(from string: String) -> UIImage{
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage{
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
        // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
        // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
        // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
        // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: round(width), height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        let context = UIGraphicsGetCurrentContext();
        context?.interpolationQuality = .none
        // Set the quality level to use when rescaling
        draw(in: CGRect(origin: .zero, size: canvasSize))
        let r = UIGraphicsGetImageFromCurrentImageContext()
        return r
    }
}

struct GenerateQRCode_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeGenerator(showingSheet: .constant(true))
    }
}

struct ShareSheet: UIViewControllerRepresentable{
    
    var image: UIImage
    
    func makeUIViewController(context: Context) -> some UIActivityViewController {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        return activityVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
}
