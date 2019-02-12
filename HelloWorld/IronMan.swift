//
//  IronMan.swift
//  HelloWorld
//
//  Created by 陈中杰 on 2019/2/12.
//  Copyright © 2019 陈中杰. All rights reserved.
//

import UIKit
import SceneKit

class IronMan: SCNNode{
    override init() {
        super.init()
        guard let url = Bundle.main.url(forResource: "art.scnassets/IronMan", withExtension: ".scn")else
        {
            fatalError("File is not existed")
        }
        guard let IronManNode = SCNReferenceNode(url: url)else{
            fatalError("Load error")
        }
        IronManNode.load()
        self.addChildNode(IronManNode)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
}
