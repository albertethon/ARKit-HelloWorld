//
//  ImageTrackingController.swift
//  HelloWorld
//
//  Created by 陈中杰 on 2019/2/12.
//  Copyright © 2019 陈中杰. All rights reserved.
//

import ARKit
import UIKit

class ImageTrackingController:UIViewController,ARSCNViewDelegate{
    var sceneView:ARSCNView!
    lazy var customNode : IronMan = {return IronMan()}()
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        view.addSubview(sceneView)
        // 先创建一个空场景
        let scene = SCNScene()
        sceneView.scene = scene
        
        // 激活锯齿，用多重采样的技术平滑渲染场景中的边缘
        sceneView.antialiasingMode = .multisampling4X
        
        sceneView.showsStatistics = true
        // 显示debug选项
        sceneView.debugOptions = [
            ARSCNDebugOptions.showWorldOrigin,
            ARSCNDebugOptions.showFeaturePoints,
        ]
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)else{
            fatalError("未找到图片！")
        }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        sceneView.session.run(configuration)
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 1. 判断anchor是否为ARImageAnchor
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        // 2. 添加模型
        node.addChildNode(customNode)
        
    }
}
