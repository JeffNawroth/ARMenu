//
//  ARViewContainer.swift
//  ARMenu
//
//  Created by Jeff Nawroth on 23.12.21.
//

import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
      

   
     /*   let boxAnchor = loadRealityComposerScene(filename: "kaesekuchen", fileExtension: "reality", sceneName: "")
        
        arView.scene.addAnchor(boxAnchor!)*/
        


        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
 /*   func createRealityURL(filename: String,
                          fileExtension: String,
                          sceneName:String) -> URL? {
        // Create a URL that points to the specified Reality file.
        guard let realityFileURL = Bundle.main.url(forResource: filename,
                                                   withExtension: fileExtension) else {
            print("Error finding Reality file \(filename).\(fileExtension)")
            return nil
        }

        // Append the scene name to the URL to point to
        // a single scene within the file.
        let realityFileSceneURL = realityFileURL.appendingPathComponent(sceneName,
                                                                        isDirectory: false)
        return realityFileSceneURL
    }
    func loadRealityComposerScene (filename: String,
                                    fileExtension: String,
                                    sceneName: String) -> (Entity & HasAnchoring)? {
        guard let realitySceneURL = createRealityURL(filename: filename,
                                                     fileExtension: fileExtension,
                                                     sceneName: sceneName) else {
            return nil
        }
        let loadedAnchor = try? Entity.loadAnchor(contentsOf: realitySceneURL)
        
        return loadedAnchor
    } */
    
}

struct ARViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ARViewContainer()
    }
}
