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
    
    private var umbrella: SCNScene?
    
    func onMount(view: ARSCNView) {
        // load our umbrella model
        umbrella = SCNScene.init(named: "Umbrella.scnassets/Umbrella.scn")
        
        if umbrella != nil {
            view.scene = umbrella!
        }
    }
    
    func onAnchorsUpdate(view: ARSCNView, body: SCNVector3, lhand: SCNVector3?, rhand: SCNVector3?) {
        if let lh = lhand {
            umbrella?.rootNode.position = lh
        }
    }
    
    func onUnmount(view: ARSCNView) {
        
    }
    
    
}
