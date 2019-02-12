//
//  WorldTrackingController.swift
//  HelloWorld
//
//  Created by 陈中杰 on 2019/2/12.
//  Copyright © 2019 陈中杰. All rights reserved.
//

import UIKit
import ARKit

class WorldTrackingController: UIViewController,ARSCNViewDelegate{
    
    var sceneView:ARSCNView!
    
    var nodeModel:SCNNode!
    var nodeName = "IronMan"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.delegate = self
        view.addSubview(sceneView)
        // 先创建一个空场景
        let scene = SCNScene()
        sceneView.scene = scene
        let modelScene = SCNScene(named: "art.scnassets/IronMan.scn")
        nodeModel = modelScene?.rootNode.childNode(withName: nodeName, recursively: true)
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
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 获取相对于整个场景sceneView的位置location
        let location = touches.first!.location(in: sceneView)
        var hitTestOptions = [SCNHitTestOption: Any]()
        // 指定boundingBoxOnly属性为true会增加搜索性能，但会牺牲几何精度
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult]  =
            sceneView.hitTest(location, options: hitTestOptions)
        
        // 删除
        if let hit = hitResults.first{
            if let node = getParent(hit.node){
                node.removeFromParentNode()
                return
            }
        }
        // 添加
        // 获取触摸得到的特征点(数组)
        let hitResultsFeaturePoints: [ARHitTestResult] =
            sceneView.hitTest(location, types: .featurePoint)
        // 取第一个特征点
        if let hit = hitResultsFeaturePoints.first {
            sceneView.session.add(anchor: ARAnchor(transform: hit.worldTransform))
        }
    }
    // 递归搜索根节点
    func getParent(_ nodeFound: SCNNode?) -> SCNNode?{
        if let node = nodeFound{
            // 找到了根节点
            if node.name == nodeName{
                return node
            }
                // 继续寻找父节点
            else if let parent = node.parent{
                return getParent(parent)
            }
        }
        return nil
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !anchor.isKind(of: ARPlaneAnchor.self){
            DispatchQueue.main.async {
                let modelClone = self.nodeModel.clone()
                modelClone.position = SCNVector3Zero
                node.addChildNode(modelClone)
            }
        }
      
    }
    
}
