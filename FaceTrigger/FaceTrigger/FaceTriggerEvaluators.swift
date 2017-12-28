//
//  FaceTriggerEvaluators.swift
//  FaceTrigger
//
//  Created by Mike Peterson on 12/27/17.
//  Copyright © 2017 Blinkloop. All rights reserved.
//

import ARKit

protocol FaceTriggerEvaluatorProtocol {
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate)
}

class SmileEvaluator: FaceTriggerEvaluatorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
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

class BlinkEvaluator: BothEvaluator {
    
    func onBoth(delegate: FaceTriggerDelegate, newBoth: Bool) {
        delegate.onBlinkDidChange?(blinking: newBoth)
        if newBoth {
            delegate.onBlink?()
        }
    }
    
    func onLeft(delegate: FaceTriggerDelegate, newLeft: Bool) {
        delegate.onBlinkLeftDidChange?(blinkingLeft: newLeft)
        if newLeft {
            delegate.onBlinkLeft?()
        }
    }
    
    func onRight(delegate: FaceTriggerDelegate, newRight: Bool) {
        delegate.onBlinkRightDidChange?(blinkingRight: newRight)
        if newRight {
            delegate.onBlinkRight?()
        }
    }
    
    init(threshold: Float) {
        super.init(threshold: threshold, leftKey: .eyeBlinkLeft, rightKey: .eyeBlinkRight, onBoth: onBoth, onLeft: onLeft, onRight: onRight)
    }
}

class BrowDownEvaluator: BothEvaluator {
    
    func onBoth(delegate: FaceTriggerDelegate, newBoth: Bool) {
        delegate.onBrowDownDidChange?(browDown: newBoth)
        if newBoth {
            delegate.onBrowDown?()
        }
    }
    
    func onLeft(delegate: FaceTriggerDelegate, newLeft: Bool) {
    }
    
    func onRight(delegate: FaceTriggerDelegate, newRight: Bool) {
    }
    
    init(threshold: Float) {
        super.init(threshold: threshold, leftKey: .browDownLeft, rightKey: .browDownRight, onBoth: onBoth, onLeft: onLeft, onRight: onRight)
    }
}

class BrowUpEvaluator: FaceTriggerEvaluatorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
        if let browInnerUp = blendShapes[.browInnerUp] {
            
            let newValue = browInnerUp.floatValue >= threshold
            if newValue != oldValue {
                delegate.onBrowUpDidChange?(browUp: newValue)
                if newValue {
                    delegate.onBrowUp?()
                }
            }
            oldValue = newValue
        }
    }
}

class SquintEvaluator: BothEvaluator {
    
    func onBoth(delegate: FaceTriggerDelegate, newBoth: Bool) {
        delegate.onSquintDidChange?(squinting: newBoth)
        if newBoth {
            delegate.onSquint?()
        }
    }
    
    func onLeft(delegate: FaceTriggerDelegate, newLeft: Bool) {
    }
    
    func onRight(delegate: FaceTriggerDelegate, newRight: Bool) {
    }
    
    init(threshold: Float) {
        super.init(threshold: threshold, leftKey: .eyeSquintLeft, rightKey: .eyeSquintRight, onBoth: onBoth, onLeft: onLeft, onRight: onRight)
    }
}

class BothEvaluator: FaceTriggerEvaluatorProtocol {
    
    private let threshold: Float
    private let leftKey: ARFaceAnchor.BlendShapeLocation
    private let rightKey: ARFaceAnchor.BlendShapeLocation
    private let onBoth: (FaceTriggerDelegate, Bool) -> Void
    private let onLeft: (FaceTriggerDelegate, Bool) -> Void
    private let onRight: (FaceTriggerDelegate, Bool) -> Void

    private var oldLeft  = false
    private var oldRight  = false
    private var oldBoth  = false
    
    init(threshold: Float,
         leftKey: ARFaceAnchor.BlendShapeLocation ,
         rightKey: ARFaceAnchor.BlendShapeLocation,
         onBoth: @escaping (FaceTriggerDelegate, Bool) -> Void,
         onLeft: @escaping (FaceTriggerDelegate, Bool) -> Void,
         onRight: @escaping (FaceTriggerDelegate, Bool) -> Void) {
        
        self.threshold = threshold
        
        self.leftKey = leftKey
        self.rightKey = rightKey
        
        self.onBoth = onBoth
        self.onLeft = onLeft
        self.onRight = onRight
    }
    
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
        // note that "left" and "right" blend shapes are mirrored so they are opposite from what a user would consider "left" or "right"
        let left = blendShapes[rightKey]
        let right = blendShapes[leftKey]
        
        var newLeft = false
        if let left = left {
            newLeft = left.floatValue >= threshold
        }

        var newRight = false
        if let right = right {
            newRight = right.floatValue >= threshold
        }

        let newBoth = newLeft && newRight
        if newBoth != oldBoth {
            onBoth(delegate, newBoth)
        } else {
            
            if newLeft != oldLeft {
                onLeft(delegate, newLeft)
            } else if newRight != oldRight {
                onRight(delegate, newRight)
            }
        }
        
        oldBoth = newBoth
        oldLeft = newLeft
        oldRight = newRight
    }
}

class MouthPuckerEvaluator: FaceTriggerEvaluatorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
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
