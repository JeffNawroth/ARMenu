//
//  ARViewContainer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    var product: Product
    
    func makeUIView(context: Context) -> ARView {
        
                let arView = ARView(frame: .zero)


        
        let url = URL(string: product.model)
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destination = documents.appendingPathComponent(url!.lastPathComponent)
                let session = URLSession(configuration: .default,
                                              delegate: nil,
                                         delegateQueue: nil)
                
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                
                let downloadTask = session.downloadTask(with: request, completionHandler: { (location: URL?,
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

                            let anchor = AnchorEntity(plane: .horizontal)
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
    

struct ARViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ARViewContainer(product: Product.dummyProducts[0])
    }
}
