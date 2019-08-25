//
//  RealmSlide.swift
//  Realm
//
//  Created by Shehryar Assad on 2019-08-24.
//  Copyright © 2019 Shahbaz Momi. All rights reserved.
//

import Foundation
import RealityKit
import ARKit

protocol RealmSlide {
    
    func onMount(view: ARSCNView)
    func onAnchorsUpdate(view: ARSCNView, body: SCNVector3, lhand: SCNVector3?, rhand: SCNVector3?)
    func onUnmount(view: ARSCNView)
    
}
