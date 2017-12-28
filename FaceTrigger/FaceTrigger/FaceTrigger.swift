//
//  FaceTrigger.swift
//  FaceTrigger
//
//  Created by Michael Peterson on 12/26/17.
//  Copyright © 2017 Blinkloop. All rights reserved.
//

import UIKit
import ARKit

@objc public protocol FaceTriggerDelegate: ARSCNViewDelegate {
    
    @objc optional func onSmile()
    @objc optional func onSmileDidChange(smiling: Bool)
    
    @objc optional func onBlink()
    @objc optional func onBlinkDidChange(blinking: Bool)
    
    @objc optional func onBlinkLeft()
    @objc optional func onBlinkLeftDidChange(blinkingLeft: Bool)
    
    @objc optional func onBlinkRight()
    @objc optional func onBlinkRightDidChange(blinkingRight: Bool)
    
    @objc optional func onMouthPucker()
    @objc optional func onMouthPuckerDidChange(mouthPuckering: Bool)
}

public class FaceTrigger: NSObject, ARSCNViewDelegate {
    
    private var sceneView: ARSCNView?
    private let sceneViewSessionOptions: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
    private let hostView: UIView
    private let delegate: FaceTriggerDelegate
    private var evaluators = [FaceTriggerEvaluatorProtocol]()
    
    public var smileThreshold: Float = 0.7
    public var blinkThreshold: Float = 0.8
    public var mouthPuckerThreshold: Float = 0.7

    public init(hostView: UIView, delegate: FaceTriggerDelegate) {
        
        self.hostView = hostView
        self.delegate = delegate
    }
    
    static public var isSupported: Bool {
        return ARFaceTrackingConfiguration.isSupported
    }
    
    public func start() {
        
        guard FaceTrigger.isSupported else {
            NSLog("FaceTrigger is not supported.")
            return
        }
        
        // evaluators
        evaluators.append(SmileEvaluator(threshold: smileThreshold))
        evaluators.append(BlinkEvaluator(threshold: blinkThreshold))
        evaluators.append(MouthPuckerEvaluator(threshold: mouthPuckerThreshold))
        
        // ARSCNView
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        
        sceneView = ARSCNView(frame: hostView.bounds)
        sceneView!.automaticallyUpdatesLighting = true
        sceneView!.session.run(configuration, options: sceneViewSessionOptions)
        sceneView!.isHidden = false
        sceneView!.delegate = self

        hostView.addSubview(sceneView!)
    }
    
    public func stop() {
    
        pause()
        sceneView?.removeFromSuperview()
    }
    
    public func pause() {
        
        sceneView?.session.pause()
    }
    
    public func unpause() {
        
        if let configuration = sceneView?.session.configuration {
            sceneView?.session.run(configuration, options: sceneViewSessionOptions)
        }
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            return
        }
        
        let blendShapes = faceAnchor.blendShapes
        evaluators.forEach {
            $0.evaluate(blendShapes, forDelegate: delegate)
        }
    }
}












