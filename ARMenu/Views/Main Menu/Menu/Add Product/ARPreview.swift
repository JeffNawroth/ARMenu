//
//  ARPreview.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 14.02.22.
//

import SwiftUI
import RealityKit
import ARKit

// AR view for previewing a selected 3D model from files
struct ARPreview: UIViewRepresentable {
    var url: URL
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addCoaching()
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        
        //load model from files, install Gestures and Collision shape
        let _ = url.startAccessingSecurityScopedResource()
        let model = try! ModelEntity.loadModel(contentsOf: url)
        url.stopAccessingSecurityScopedResource()
        model.generateCollisionShapes(recursive: true)
        arView.installGestures(for: model)
        
        //Add Model to horizontal plane
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
