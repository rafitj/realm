//
//  ImageSlide.swift
//  Realm
//
//  Created by Shehryar Assad on 2019-08-24.
//  Copyright © 2019 Shahbaz Momi. All rights reserved.
//

import Foundation
import ARKit
import RealityKit

class ImageSlide: RealmSlide {
    
    private let src: String
    private let plane: SCNNode
    private let snapping: Bool
    private var trackHand = true
    private var snapStart = 0.0
    
    init(src: String, w: CGFloat, h: CGFloat, snap: Bool = false) {
        self.src = src
        self.plane = SCNNode(geometry: SCNPlane(width:w, height: h))
        snapping = snap
    }
    
    func millis() -> Double {
        return Date().timeIntervalSince1970 * 1000.0
    }
    
    func onMount(view: ARSCNView) {
        let src = UIImage(named: self.src)
        plane.geometry?.firstMaterial?.isDoubleSided = true
        plane.geometry?.firstMaterial?.diffuse.contents = src
        view.scene.rootNode.addChildNode(plane)
        
        trackHand = true
        snapStart = millis()
    }
    
    func onAnchorsUpdate(view: ARSCNView, body: SCNVector3, lhand: SCNVector3?, rhand: SCNVector3?) {
        if let rh = rhand {
            if trackHand {
                plane.position = rh
            }
        }
        
        if millis() - snapStart >= 2000 && snapping && trackHand {
            trackHand = false
        }
    }
    
    func onUnmount(view: ARSCNView) {
        plane.removeFromParentNode()
    }
    
    
}
