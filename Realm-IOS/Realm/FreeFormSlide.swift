//
//  FreeFormSlide.swift
//  Realm
//
//  Created by Shehryar Assad on 2019-08-24.
//  Copyright © 2019 Shahbaz Momi. All rights reserved.
//

import Foundation
import ARKit
import RealityKit

class FreeFormSlide: RealmSlide {
    
    var draw = false
    var drawFresh = true
    var drawIndex = -1
    var drawings = [SCNNode]()

    
    func onMount(view: ARSCNView) {
    }
    
    func onAnchorsUpdate(view: ARSCNView, body: SCNVector3, lhand: SCNVector3?, rhand: SCNVector3?) {
        if draw {
            addToDraw(v: lhand!, arView: view)
        }
    }
    
    func onUnmount(view: ARSCNView) {
    }
    
    func toggleDraw() {
        draw = !draw
        drawFresh = true
    }
    
    private var gravity = false
    
    func toggleGravity() {
        gravity = !gravity;
        changeGravity(on: gravity)
    }
    
    func changeGravity(on: Bool) {
        for node in drawings {
            for c in node.childNodes {
                var type = SCNPhysicsBodyType.static
                if on {
                    type = .dynamic
                }
                c.physicsBody?.type = type
                c.physicsBody?.isAffectedByGravity = on
            }
        }
    }
    
    func addToDraw(v: SCNVector3, arView: ARSCNView) {
        if(drawFresh) {
            drawIndex += 1
            drawFresh = false
            
            // create a new parent node
            let newNode = SCNNode()
            drawings.append(newNode)
            
            arView.scene.rootNode.addChildNode(newNode)
        }
        
        
        let geo = SCNSphere(radius: 0.01)
        let node = SCNNode(geometry: geo)
        node.position = v
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        
        let body = SCNPhysicsBody(type: .static, shape: nil)
        body.mass = 1.0
        body.isAffectedByGravity = false
        node.physicsBody = body
    
        let current = drawings[drawIndex]
        current.addChildNode(node)
    }

}
