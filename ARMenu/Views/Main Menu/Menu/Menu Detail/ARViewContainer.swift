//
//  ARViewContainer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    var product: Product
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        arView.addCoaching()
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config, options: [])
        
        
        
        let url = URL(string: product.model)
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
                    let model = try ModelEntity.loadModel(contentsOf: destination)
                    model.generateCollisionShapes(recursive: true)
                    arView.installGestures(for: model)
                
                    
                    let anchor = AnchorEntity(plane: .horizontal )
                    anchor.addChild(model)
                    arView.scene.addAnchor(anchor)
                    
                    //  model.playAnimation(model.availableAnimations.first!.repeat())
                } catch {
                    print("Fail loading entity.")
                }
            }
        })
        downloadTask.resume()
        
        
        return arView
        
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    
    
}


extension ARView: ARCoachingOverlayViewDelegate{
    func addCoaching(){
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = self.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        coachingOverlay.goal = .horizontalPlane
        self.addSubview(coachingOverlay)
        
    }
    
//    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//           print("found")
//       }
}


struct ARViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ARViewContainer(product: Product.dummyProduct)
    }
}
