//
//  FaceTrackingController.swift
//  HelloWorld
//
//  Created by 陈中杰 on 2019/2/12.
//  Copyright © 2019 陈中杰. All rights reserved.
//

import UIKit
import ARKit

class FaceTrackingController:UIViewController,ARSCNViewDelegate{
    // 1.先创建一个 ARSCNView 类型的属性sceneView
    var sceneView:ARSCNView!
    lazy var customNode: IronMan = {return IronMan()}()
    // 2.重写viewDidLoad()方法，设置scene
    override func viewDidLoad() {
        super.viewDidLoad()
        // 2.1实例化一个sceneView，设置delegate为自身，传入view.addSubview()
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        view.addSubview(sceneView)
        // 2.2创建一个空场景赋给sceneView.scene
        let scene = SCNScene()
        sceneView.scene = scene
        // 激活锯齿，用多重采样的技术平滑渲染场景中的边缘
        sceneView.antialiasingMode = .multisampling4X
        // 显示统计信息
        sceneView.showsStatistics = true
        // 显示debug选项
        sceneView.debugOptions = [
            ARSCNDebugOptions.showWorldOrigin,
            ARSCNDebugOptions.showFeaturePoints,
        ]
    }
    // 3.重写viewWillAppear()方法，设置session的configuration
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    // 4.重写renderer didAdd
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 4.1判断Anchor是否为ARFaceAnchor
        guard anchor is ARFaceAnchor else{
            return
        }
        // 4.2在检测到的人脸处添加模型
        node.addChildNode(customNode)
    }
}
