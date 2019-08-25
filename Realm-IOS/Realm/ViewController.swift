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
    
    var drawer = FreeFormSlide()
    
    var slideIndex = 0
    let slides: [RealmSlide] = [IntroSlide(),
                                ImageSlide(src: "slides/Slide1.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide2.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide3.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide4.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide5.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide6.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide7.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide8.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide9.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide10.jpg", w: 2.00, h: 1.25, snap: true),
                                ImageSlide(src: "slides/Slide11.jpg", w: 2.00, h: 1.25, snap: true),
                                RainSlide()]
    @IBOutlet var previous: UIButton!
    @IBOutlet var gravity: UIButton!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var draw: UIButton!
    // drawing related shit
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        arView.session.delegate = self
        geometry.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
    
        gravity.addTarget(self, action: #selector(toggleGravity), for: .touchUpInside)
        
        nextButton.addTarget(self, action: #selector(nextSlide), for: .touchUpInside)
        
        draw.addTarget(self, action: #selector(toggleDraw), for: .touchUpInside)
        
        previous.addTarget(self, action: #selector(previousSlide), for: .touchUpInside)
        
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
        arView.autoenablesDefaultLighting = true
        
        slides[slideIndex].onMount(view: arView)
        drawer.onMount(view: arView)
    }

    @objc func nextSlide() {
        if slideIndex >= slides.count - 1 {
            return;
        }
        slides[slideIndex].onUnmount(view: arView)
        slideIndex += 1
        slides[slideIndex].onMount(view: arView)
    }
    
    @objc func toggleDraw() {
        drawer.toggleDraw()
    }
    
    @objc func toggleGravity() {
        drawer.toggleGravity()
    }
    
    @objc func previousSlide() {
        if slideIndex <= 0 {
            return;
        }
        slides[slideIndex].onUnmount(view: arView)
        slideIndex -= 1
        slides[slideIndex].onMount(view: arView)
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
            
            slides[slideIndex].onAnchorsUpdate(view: arView, body: SCNVector3(bodyPosition), lhand: lh, rhand: rh)
            drawer.onAnchorsUpdate(view: arView, body: SCNVector3(bodyPosition), lhand: lh, rhand: rh)
        }
    
    }
    
    func jointPosition(bodyPosition: SIMD3<Float>, bodyAnchor: ARBodyAnchor, jointName: ARSkeleton3D.JointName) -> SCNVector3? {
        guard let matrix = bodyAnchor.skeleton.modelTransform(for: jointName) else { return nil; }
        let pos = simd_make_float3(matrix.columns.3)
        return SCNVector3(bodyPosition + pos)
    }
    
}
