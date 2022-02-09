//
//  GenerateQRCode.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 09.02.22.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct QRCodeGenerator: View {
    
    @State private var name = "Jeff"
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        Image(uiImage: generateQRCode(from: name))
            .resizable()
            .interpolation(.none)
            .scaledToFit()
            .padding()
    }
    
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

struct GenerateQRCode_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeGenerator()
    }
}
