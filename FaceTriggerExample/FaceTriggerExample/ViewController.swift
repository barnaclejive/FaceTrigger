//
//  ViewController.swift
//  FaceTriggerExample
//
//  Created by Mike Peterson on 12/26/17.
//  Copyright © 2017 Blinkloop. All rights reserved.
//

import UIKit
import FaceTrigger
import ARKit

class ViewController: UIViewController {

    @IBOutlet var previewContainer: UIView!
    @IBOutlet var logTextView: UITextView!

    var faceTrigger: FaceTrigger?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logTextView.text = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(pause), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unpause), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        faceTrigger = FaceTrigger(hostView: previewContainer, delegate: self)
        faceTrigger?.start()
    }
    
    @objc private func pause() {
        faceTrigger?.pause()
    }
    
    @objc private func unpause() {
        faceTrigger?.unpause()
    }
    
    private func updateLog(_ eventText: String) {
    
        DispatchQueue.main.async {
            let currentText = self.logTextView.text ?? ""
            self.logTextView.text = "\(eventText)\n\n\(currentText)"
        }
    }
    
    @IBAction func clearLogAction() {
        logTextView.text = nil
    }
}

extension ViewController: FaceTriggerDelegate {
    
    func onSmileDidChange(smiling: Bool) {
        updateLog("onSmileDidChange \(smiling)")
    }
    
    func onSmile() {
        updateLog("smile")
    }
    
    func onBlinkLeftDidChange(blinkingLeft: Bool) {
        updateLog("onBlinkLeftDidChange \(blinkingLeft)")
    }
    
    func onBlinkLeft() {
        updateLog("blink left")
    }
    
    func onBlinkRightDidChange(blinkingRight: Bool) {
        updateLog("onBlinkRightDidChange \(blinkingRight)")
    }
    
    func onBlinkRight() {
        updateLog("blink right")
    }
    
    func onBlinkDidChange(blinking: Bool) {
        updateLog("onBlinkDidChange \(blinking)")
    }
    
    func onBlink() {
        updateLog("blink")
    }
    
    func onMouthPuckerDidChange(mouthPuckering: Bool) {
        updateLog("onMouthPuckerDidChange \(mouthPuckering)")
    }
    
    func onMouthPucker() {
        updateLog("mouth pucker")
    }
}
