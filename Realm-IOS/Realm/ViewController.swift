/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The sample app's main view controller.
*/

import UIKit
import RealityKit
import ARKit
import Combine

class ViewController: UIViewController, ARSessionDelegate {
    
    @IBOutlet var arView: ARSCNView!
    
    // The 3D character to display.
    var character: BodyTrackedEntity?
    
    let geometry = SCNNode(geometry: SCNSphere(radius: 0.05))
    let geometry2 = SCNNode(geometry: SCNSphere(radius: 0.05))
    let geometry3 = SCNNode(geometry: SCNSphere(radius: 0.05))
    
    var slide: RealmSlide?
    
    // drawing related shit
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        geometry.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        // If the iOS device doesn't support body tracking, raise a developer error for
        // this unhandled case.
        guard ARBodyTrackingConfiguration.isSupported else {
            fatalError("This feature is only supported on devices with an A12 chip")
        }

        // Run a body tracking configration.
        let configuration = ARBodyTrackingConfiguration()
//        configuration.automaticSkeletonScaleEstimationEnabled = true
//        configuration.isAutoFocusEnabled = true
//        configuration.automaticImageScaleEstimationEnabled = true
        arView.session.run(configuration)
        
        slide = RainSlide()
        
        slide?.onMount(view: arView)
    }

    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        for anchor in anchors {
            guard let bodyAnchor = anchor as? ARBodyAnchor else { continue }
        
            // Update the position of the character anchor's position.
            let bodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
            geometry.position = SCNVector3(bodyPosition);
            
            if geometry.parent == nil {
                arView.scene.rootNode.addChildNode(geometry)
            }
            
            let lh = jointPosition(bodyPosition: bodyPosition, bodyAnchor: bodyAnchor, jointName: .leftHand)
            
            if lh != nil {
                geometry2.position = lh!
            }
            
            if geometry2.parent == nil {
                  arView.scene.rootNode.addChildNode(geometry2)
              }
            
            let rh = jointPosition(bodyPosition: bodyPosition, bodyAnchor: bodyAnchor, jointName: .rightHand)

            if rh != nil {
                geometry3.position = rh!
            }
            
            if geometry3.parent == nil {
                  arView.scene.rootNode.addChildNode(geometry3)
              }
            
            slide?.onAnchorsUpdate(view: arView, body: SCNVector3(bodyPosition), lhand: lh, rhand: rh)
        }
    
    }
    
    func jointPosition(bodyPosition: SIMD3<Float>, bodyAnchor: ARBodyAnchor, jointName: ARSkeleton3D.JointName) -> SCNVector3? {
        guard let matrix = bodyAnchor.skeleton.modelTransform(for: jointName) else { return nil; }
        let pos = simd_make_float3(matrix.columns.3)
        return SCNVector3(bodyPosition + pos)
    }
    
}
