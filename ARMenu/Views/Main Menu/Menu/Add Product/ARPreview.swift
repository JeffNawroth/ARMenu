//
//  ARPreview.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 14.02.22.
//

import SwiftUI
import RealityKit
import ARKit

struct ARPreview: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addCoaching()
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        
        url.startAccessingSecurityScopedResource()
        let model = try! ModelEntity.loadModel(contentsOf: url)
        url.stopAccessingSecurityScopedResource()
        model.generateCollisionShapes(recursive: true)
        arView.installGestures(for: model)
        
        
        let anchor = AnchorEntity(plane: .horizontal )
        anchor.addChild(model)
        arView.scene.addAnchor(anchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ARPreview_Previews: PreviewProvider {
    static var previews: some View {
        ARPreview(url: URL(string: "")!)
    }
}
