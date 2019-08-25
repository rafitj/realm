//
//  RainSlide.swift
//  Realm
//
//  Created by Shehryar Assad on 2019-08-24.
//  Copyright © 2019 Shahbaz Momi. All rights reserved.
//

import Foundation
import RealityKit
import ARKit

class RainSlide: RealmSlide {
    
    let RAIN_COUNT = 100
    
    private var rain = [SCNNode]()
    private var ages = [Double]()
    private var offset = SCNVector3()
    private var timer: Timer?
        
    var blocker = SCNNode()
        
    func onMount(view: ARSCNView) {
        blocker = SCNNode(geometry: SCNBox(width: 1.0, height: 0.1, length: 1.0, chamferRadius: 0.5))
        blocker.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        
        let phys = SCNPhysicsBody(type: .kinematic, shape: nil)
        phys.isAffectedByGravity = false
        blocker.physicsBody = phys
        
        view.scene.rootNode.addChildNode(blocker)
                
        timer = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true, block: {
            timer in
            self.updateRain(view: view)
        })
    }
    
    func randPos(_ node: SCNNode) {
        let position = SCNVector3(Float.random(in: -2.0...2.0), 5.0, Float.random(in: -2...2.0))
        node.position = SCNVector3(position.x + offset.x, position.y + offset.y, position.z + offset.z)
    }
    
    func makeRainNode() -> SCNNode {
        let node = SCNNode(geometry: SCNCylinder(radius: 0.01, height: 0.15))
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        // random x and z, set y
        randPos(node)
        let body = SCNPhysicsBody(type: .dynamic, shape: nil)
        body.mass = 0.1
        body.isAffectedByGravity = true
        node.physicsBody = body
        
        return node
    }
    
    func millis() -> Double {
        return Date().timeIntervalSince1970 * 1000.0
    }
    
    func updateRain(view: ARSCNView) {
        if rain.count == 0 {
            // make a bunch of rain
            for _ in 0...RAIN_COUNT {
                let node = makeRainNode()
                rain.append(node)
                ages.append(millis() + Double.random(in: 0...1500.0))
                view.scene.rootNode.addChildNode(node)
            }
            return
        }
        
        let m = millis()
        
        // remove all less than < -4.0
        for i in 0...RAIN_COUNT {
            if m - ages[i] > 1000.0 {
                let current = rain[i]
                current.removeFromParentNode()
                let node = makeRainNode()
                rain[i] = (node)
                ages[i] = (millis() + Double.random(in: 0...1000.0))
                view.scene.rootNode.addChildNode(node)
            }
        }
    }
        
    func onAnchorsUpdate(view: ARSCNView, body: SCNVector3, lhand: SCNVector3?, rhand: SCNVector3?) {
        if let lh = lhand {
            blocker.position = SCNVector3(lh.x, lh.y + 0.5, lh.z)
        }
        offset = body
    }
    
    func onUnmount(view: ARSCNView) {
        timer?.invalidate()
        
        blocker.removeFromParentNode()
        for r in rain {
            r.removeFromParentNode()
        }
    }
    
    
}
