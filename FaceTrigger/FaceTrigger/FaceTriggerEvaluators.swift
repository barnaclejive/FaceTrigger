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
    
    override func onBoth(_ delegate: FaceTriggerDelegate, _ newBoth: Bool) {
        delegate.onBlinkDidChange?(blinking: newBoth)
        if newBoth {
            delegate.onBlink?()
        }
    }
    
    override func onLeft(_ delegate: FaceTriggerDelegate, _ newLeft: Bool) {
        delegate.onBlinkLeftDidChange?(blinkingLeft: newLeft)
        if newLeft {
            delegate.onBlinkLeft?()
        }
    }
    
    override func onRight(_ delegate: FaceTriggerDelegate, _ newRight: Bool) {
        delegate.onBlinkRightDidChange?(blinkingRight: newRight)
        if newRight {
            delegate.onBlinkRight?()
        }
    }
    
    init(threshold: Float) {
        super.init(threshold: threshold, leftKey: .eyeBlinkLeft, rightKey: .eyeBlinkRight)
    }
}

class BrowDownEvaluator: BothEvaluator {
    
    override func onBoth(_ delegate: FaceTriggerDelegate, _ newBoth: Bool) {
        delegate.onBrowDownDidChange?(browDown: newBoth)
        if newBoth {
            delegate.onBrowDown?()
        }
    }
    
    init(threshold: Float) {
        super.init(threshold: threshold, leftKey: .browDownLeft, rightKey: .browDownRight)
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
    
    override func onBoth(_ delegate: FaceTriggerDelegate, _ newBoth: Bool) {
        delegate.onSquintDidChange?(squinting: newBoth)
        if newBoth {
            delegate.onSquint?()
        }
    }
    
    init(threshold: Float) {
        super.init(threshold: threshold, leftKey: .eyeSquintLeft, rightKey: .eyeSquintRight)
    }
}

protocol BothEvaluatorProtocol {
    func onBoth(_: FaceTriggerDelegate, _: Bool) -> Void
    func onLeft(_: FaceTriggerDelegate, _: Bool) -> Void
    func onRight(_: FaceTriggerDelegate, _: Bool) -> Void
}

class BothEvaluator: FaceTriggerEvaluatorProtocol, BothEvaluatorProtocol {
    
    private let threshold: Float
    private let leftKey: ARFaceAnchor.BlendShapeLocation
    private let rightKey: ARFaceAnchor.BlendShapeLocation

    private var oldLeft  = false
    private var oldRight  = false
    private var oldBoth  = false
    
    init(threshold: Float,
         leftKey: ARFaceAnchor.BlendShapeLocation ,
         rightKey: ARFaceAnchor.BlendShapeLocation) {
        
        self.threshold = threshold
        
        self.leftKey = leftKey
        self.rightKey = rightKey
    }
    
    func onBoth(_ delegate: FaceTriggerDelegate, _ newBoth: Bool) {
    }
    
    func onLeft(_ delegate: FaceTriggerDelegate, _ newLeft: Bool) {
    }
    
    func onRight(_ delegate: FaceTriggerDelegate, _ newRight: Bool) {
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

class CheekPuffEvaluator: FaceTriggerEvaluatorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
        if let cheekPuff = blendShapes[.cheekPuff] {
            
            let newValue = cheekPuff.floatValue >= threshold
            if newValue != oldValue {
                delegate.onCheekPuffDidChange?(cheekPuffing: newValue)
                if newValue {
                    delegate.onCheekPuff?()
                }
            }
            oldValue = newValue
        }
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

class JawOpenEvaluator: FaceTriggerEvaluatorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        
        if let jawOpen = blendShapes[.jawOpen] {
            
            let newValue = jawOpen.floatValue >= threshold
            if newValue != oldValue {
                delegate.onJawOpenDidChange?(jawOpening: newValue)
                if newValue {
                    delegate.onJawOpen?()
                }
            }
            oldValue = newValue
        }
    }
}

class JawLeftEvaluator: FaceTriggerEvaluatorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        // note that "left" and "right" blend shapes are mirrored so they are opposite from what a user would consider "left" or "right"
        if let jawLeft = blendShapes[.jawRight] {
            
            let newValue = jawLeft.floatValue >= threshold
            if newValue != oldValue {
                delegate.onJawLeftDidChange?(jawLefting: newValue)
                if newValue {
                    delegate.onJawLeft?()
                }
            }
            oldValue = newValue
        }
    }
}

class JawRightEvaluator: FaceTriggerEvaluatorProtocol {
    
    private var oldValue  = false
    private let threshold: Float
    
    init(threshold: Float) {
        self.threshold = threshold
    }
    
    func evaluate(_ blendShapes: [ARFaceAnchor.BlendShapeLocation : NSNumber], forDelegate delegate: FaceTriggerDelegate) {
        // note that "left" and "right" blend shapes are mirrored so they are opposite from what a user would consider "left" or "right"
        if let jawRight = blendShapes[.jawLeft] {
            
            let newValue = jawRight.floatValue >= threshold
            if newValue != oldValue {
                delegate.onJawRightDidChange?(jawRighting: newValue)
                if newValue {
                    delegate.onJawRight?()
                }
            }
            oldValue = newValue
        }
    }
}
