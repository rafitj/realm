//
//  IntroSlide.swift
//  Realm
//
//  Created by Shehryar Assad on 2019-08-24.
//  Copyright © 2019 Shahbaz Momi. All rights reserved.
//

import Foundation
import ARKit
import RealityKit

class IntroSlide: RealmSlide {
    
    var nodes = [SCNNode]()
    var textWidth: Float = 0.0
    let arrow = UIImage(named: "arrow.png")
    let arrow2 = UIImage(named: "arrow2.png")
    
    var arrowNodes = [SCNNode]()
    var offsets = [SCNVector3]()
    
    func onMount(view: ARSCNView) {
        let src = "Immersive\nPresentations"
        let lines = src.split(separator: "\n")
        
        for line in lines {
            let text = SCNText(string: line, extrusionDepth: 0.1);
        
            text.font = text.font.withSize(0.2)
            
            let textNode = SCNNode(geometry: text)
            let (m1, m2) = textNode.boundingBox
            textWidth = max(abs(m2.x - m1.x), textWidth)
            
            nodes.append(textNode)
            view.scene.rootNode.addChildNode(textNode)
        }
        
        // 6 arrows
        let radius = 1.0
        for i in 0...5 {
            let angle = 2 * Double.pi * (Double(i) / 6.0)
            let offset = SCNVector3(cos(angle) * radius, sin(angle) * radius, 0)
            offsets.append(offset)
            
            let node = SCNNode(geometry: SCNPlane(width: 0.25, height: 0.25))
            
            if((2...4).contains(i)) {
                node.geometry?.firstMaterial?.diffuse.contents = arrow
            } else {
                node.geometry?.firstMaterial?.diffuse.contents = arrow2
            }
            
            arrowNodes.append(node)
            view.scene.rootNode.addChildNode(node)
        }
    }
    
    func onAnchorsUpdate(view: ARSCNView, body: SCNVector3, lhand: SCNVector3?, rhand: SCNVector3?) {
        for i in 0...nodes.count - 1 {
            let gapping = Float(i) * 0.2
            nodes[nodes.count - i - 1].position = SCNVector3(body.x - textWidth / 2.0, body.y + 0.1 + gapping, body.z)
        }
        for i in 0...5 {
            arrowNodes[i].position = SCNVector3(body.x + offsets[i].x, body.y + offsets[i].y, body.z + offsets[i].z)
        }
    }
    
    func onUnmount(view: ARSCNView) {
        for node in nodes {
            node.removeFromParentNode()
        }
        for node in arrowNodes {
            node.removeFromParentNode()
        }
    }
    
    
}
