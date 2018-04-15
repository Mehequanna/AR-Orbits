//
//  ViewController.swift
//  ARapp
//
//  Created by Stephen Emery on 3/13/18.
//  Copyright © 2018 Stephen Emery. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Set plane detection to horizontal
        configuration.planeDetection = .horizontal;
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // Called when user touches the screen.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // Gives the location of the screen touch.
            let touchLocation = touch.location(in: sceneView)
            
            // Hit test is performed to get the 3D coordinates from the 2D coordinates of the screen touch location.
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            // If there is a result present using hitTest, do this.
            if let hitResult = results.first {
                let boxScene = SCNScene(named: "art.scnassets/box.scn")!
                
                if let boxNode = boxScene.rootNode.childNode(withName: "box", recursively: true) {
                    boxNode.position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + 0.15, hitResult.worldTransform.columns.3.z)
                    
                    sceneView.scene.rootNode.addChildNode(boxNode)
                }
            }
        }
    }
    
    // This code is called whenever a horizontal plane is detected.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
        if anchor is ARPlaneAnchor {
            // Downcast to ARPlaneAnchor because we are only dealing with a horizontal plane.
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // Create rectangle to see plane.
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            // A node is a postion in 3d space
            let planeNode = SCNNode()
            
            // Set the position of the node based on the anchor response.
            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            // Flip plane to be on xz axis not xy
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            // Create material object
            let gridMaterial = SCNMaterial()
            
            // Set object material image
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            
            // Assign material to plane
            plane.materials = [gridMaterial]
            
            // Assign position to the plane
            planeNode.geometry = plane
            
            // Add plane node to the scene
            node.addChildNode(planeNode)
        } else {
            return
        }
        
    }
}
