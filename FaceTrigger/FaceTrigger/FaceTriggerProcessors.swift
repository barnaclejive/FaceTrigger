//
//  FaceTriggerProcessors.swift
//  FaceTrigger
//
//  Created by Mike Peterson on 12/27/17.
//  Copyright © 2017 Blinkloop. All rights reserved.
//

import ARKit

protocol FaceTriggerProcessorProtocol {
    func process(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate)
}



class SmileProcessor: FaceTriggerProcessorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func process(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
        if let mouthSmileLeft = blendShapes[.mouthSmileLeft], let mouthSmileRight = blendShapes[.mouthSmileRight] {
            
            let newValue = ((mouthSmileLeft.floatValue + mouthSmileRight.floatValue) / 2.0) >= threshold
            if newValue != oldValue {
                delegate.onSmileDidChange?(smiling: newValue)
                if newValue {
                    delegate.onSmile?()
                }
            }
            oldValue = newValue
        }
    }
}

class BlinkProcessor: FaceTriggerProcessorProtocol {
    
    private var oldBlinkLeft  = false
    private var oldBlinkRight  = false
    private var oldBlinkBoth  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func process(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
        // note that "left" and "right" blend shapes are mirrored so they are opposite from what a user would consider "left" or "right"
        // the FaceTriggerDelegate functions are named as a user would expect, so an "eyeBlinkLeft" event triggers onBlinkRightDidChange
        let eyeBlinkLeft = blendShapes[.eyeBlinkLeft]
        let eyeBlinkRight = blendShapes[.eyeBlinkRight]
        
        var hasNewLeft = false
        var newBlinkLeft = false
        var hasNewRight = false
        var newBlinkRight = false
        
        // left
        if let eyeBlinkLeft = eyeBlinkLeft {
            
            newBlinkLeft = eyeBlinkLeft.floatValue >= threshold
            hasNewLeft = true
            
            if newBlinkLeft != oldBlinkLeft {
                delegate.onBlinkRightDidChange?(blinkingRight: newBlinkLeft)
                if newBlinkLeft {
                    delegate.onBlinkRight?()
                }
            }
            
            oldBlinkLeft = newBlinkLeft
        }
        
        // right
        if let eyeBlinkRight = eyeBlinkRight {
            
            newBlinkRight = eyeBlinkRight.floatValue >= threshold
            hasNewRight = true
            
            if newBlinkRight != oldBlinkRight {
                delegate.onBlinkLeftDidChange?(blinkingLeft: newBlinkRight)
                if newBlinkRight {
                    delegate.onBlinkLeft?()
                }
            }
            
            oldBlinkRight = newBlinkRight
        }
        
        // both
        if hasNewLeft && hasNewRight  {
            
            let newBlinkBoth = newBlinkLeft && newBlinkRight
            
            if newBlinkBoth != oldBlinkBoth {
                delegate.onBlinkDidChange?(blinking: newBlinkBoth)
                if newBlinkBoth {
                    delegate.onBlink?()
                }
            }
            
            oldBlinkBoth = newBlinkBoth
        }
    }
}

class MouthPuckerProcessor: FaceTriggerProcessorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func process(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
        if let mouthPucker = blendShapes[.mouthPucker] {
            
            let newValue = mouthPucker.floatValue >= threshold
            if newValue != oldValue {
                delegate.onMouthPuckerDidChange?(mouthPuckering: newValue)
                if newValue {
                    delegate.onMouthPucker?()
                }
            }
            oldValue = newValue
        }
    }
}
