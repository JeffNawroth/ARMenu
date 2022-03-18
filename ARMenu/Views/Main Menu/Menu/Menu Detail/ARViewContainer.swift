//
//  ARViewContainer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import RealityKit
import ARKit

// AR view for 3D models loaded from database
struct ARViewContainer: UIViewRepresentable {
    var product: Product
    @Binding var loading: Bool
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addCoaching()
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        
        //Load 3D model from the database using the URL
        if let url = product.model{
            loading = true
            let url = URL(string: url)
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destination = documents.appendingPathComponent(url!.lastPathComponent)
            let urlSession = URLSession(configuration: .default,
                                        delegate: nil,
                                        delegateQueue: nil)
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            
            let downloadTask = urlSession.downloadTask(with: request, completionHandler: { (location: URL?,
                                                                                            response: URLResponse?,
                                                                                            error: Error?) -> Void in
                
                let fileManager = FileManager.default
                
                if fileManager.fileExists(atPath: destination.path) {
                    try! fileManager.removeItem(atPath: destination.path)
                }
                try! fileManager.moveItem(atPath: location!.path,
                                          toPath: destination.path)
                
                DispatchQueue.main.async {
                    do {
                        loading = false
                        //Install gestures and collision shape for model
                        let model = try ModelEntity.loadModel(contentsOf: destination)
                        model.generateCollisionShapes(recursive: true)
                        arView.installGestures(for: model)
                    
                        //Add Model to horizontal plane
                        let anchor = AnchorEntity(plane: .horizontal )
                        anchor.scale = [1,1,1] * 0.4
                        anchor.position = [0,0,0]
                        anchor.addChild(model)
                        arView.scene.addAnchor(anchor)
                        
                    } catch {
                        print("Fail loading entity.")
                    }
                }
            })
            downloadTask.resume()
            
            
            
        }
        return arView

    }
        
    
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
    
}


extension ARView: ARCoachingOverlayViewDelegate{
    //Pictorial guide for recognizing a horizontal surface
    func addCoaching(){
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
        
    }
}


struct ARViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ARViewContainer(product: Product.dummyProduct, loading: .constant(false))
    }
}
