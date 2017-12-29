FaceTrigger
===================

[![Build Status](https://travis-ci.org/barnaclejive/FaceTrigger.svg?branch=master)](https://travis-ci.org/barnaclejive/FaceTrigger)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/FaceTrigger.svg)](https://img.shields.io/cocoapods/v/FaceTrigger.svg)

# Introduction
`FaceTrigger` is a simple to use class that hides the details of using `ARKit`'s `ARSCNView` to recognize facial gestures via `ARFaceAnchor.BlendShapeLocation`s

Simply create an instance of `FaceTrigger` and register yourself as its delegate. As a FaceTrigger delegate, your class will know when face gestures occur. All delegate functions are optional.

`FaceTrigger` recognizes the following gestures:
* Smile
* Blink
- Wink Right
- Wink Left
* Brow Down
* Brow Up
* Squint
* Mouth Pucker

*Additional gestures can be added by to the project by implementing a new class that conforms to `FaceTriggerEvaluatorProtocol`. Submit a PR!*


# Demo

For first-hand experience run the FaceTriggerExample application on a supported device.

FaceTrigger requires a device that supports ARKit face tracking. For example, an actual iPhone X.

[Download Full Video Demo](https://raw.githubusercontent.com/barnaclejive/FaceTrigger/master/demo.mov)

![Demo Still](https://github.com/barnaclejive/FaceTrigger/blob/master/demo.jpg?raw=true)


# Installation

## CocoaPods

For general information about using CocoaPods, please read: [Using CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

Add `FaceTrigger` to your `Podfile`.

```ruby
pod 'FaceTrigger'
```

Then install it.

```bash
$ pod install
```

## Manual

Drag the `FaceTrigger.xcodeproj` file into your your project.

or

Copy the files .swift files from the FaceTrigger folder into your project: `FaceTrigger/FaceTrigger/*.swift`


# Usage

## TLDR; example

```swift
import UIKit
import FaceTrigger

class MyViewController: UIViewController {

  var faceTrigger: FaceTrigger?

  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)

      faceTrigger = FaceTrigger(hostView: previewContainer, delegate: self)
      faceTrigger?.start()
  }
}

extension MyViewController: FaceTriggerDelegate {
  func onSmile() {
      print("smile")
  }
}
```


## Initialization

Import `FaceTrigger`.

```swift
import FaceTrigger
```

Create an instance variable of type FaceTrigger in your view controller.

```swift
class MyViewController: UIViewController {

  var faceTrigger: FaceTrigger?
```

In `viewDidLoad`, create a new instance of `FaceTrigger` and assign it to your controller's instance variable.

```swift
override func viewDidAppear(_ animated: Bool) {
  super.viewDidAppear(animated)

  faceTrigger = FaceTrigger(hostView: view, delegate: self)
  faceTrigger?.start()
}
```

**Note that you must create an instance variable in your controller. You cannot create it locally.
This will NOT work:** <span style="color:red;text-decoration:line-through">let faceTrigger = FaceTrigger(hostView: view, delegate: self)</span>. The `ARSCNViewDelegate` functions won't trigger. If you know why, please let me know... I'm very curious but have not dug into it.

```swift
FaceTrigger(hostView: view, delegate: self)
```

**`hostView`**

This is a view that will contain the ARSCNView. The `ARSCNView` is a view that shows the video stream of the user's face.

*You do not need to display this view.* If you want, just pass your view controller's `view` object and set the `hidePreview` attribute to `true`. The default to `false` and it will display the video stream.

If you *do* want to show the video stream of the user's face, pass any `UIView` in your UI as the `hostView` and do not set the `hidePreview` attribute (or explicitly set it to `true`).

**`delegate`**

The class conforms to the `FaceTriggerDelegate` protocol that will receive callbacks when facial gestures are detected. In a simple case this can just be your view controller. For example:

```swift
extension MyViewController: FaceTriggerDelegate {

    func onSmile() {
        print("smile")
    }
}
```

## Responding to facial gestures

The `FaceTriggerDelegate` defines several functions that will be called when a gestures is recognized. All `FaceTriggerDelegate` protocol functions are optional - your application only needs to to implement those gestures that you care about.

See the `FaceTriggerDelegate` class for all available delegate functions.

For example, to detect when the user smiles, your delegate may implement the `onSmile` function.

```swift
func onSmile() {
  print("smile")
}
```

Each gesture also an "`onChange`" function. If you need need extra control to know when the user stops performing the gesture. For example:

```swift
func onSmileDidChange(smiling: Bool) {
  print("onSmileDidChange \(smiling)")
}
```

In the example above, the `smiling` parameter will be `true` when the user begins smiling, and `false` when the user stops smiling. Note that when `smiling` is `true`, the `onSmile` function will also be run if you have implemented it.

```swift
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

  @objc optional func onBrowDown()
  @objc optional func onBrowDownDidChange(browDown: Bool)

  @objc optional func onBrowUp()
  @objc optional func onBrowUpDidChange(browUp: Bool)

  @objc optional func onSquint()
  @objc optional func onSquintDidChange(squinting: Bool)
}
```

## Additional options

You may set additional options on the `FaceTrigger` object before calling `.start()` to modify its behavior. You must set these prior to calling `.start()`.

### Gesture thresholds

Each gesture is triggered when the user perform the gesture to a certain degree, on a scale from 0.0 to 1.0. For example, a small smile may only have a value of 0.2, and if the `smileThreshold` is 0.8, the `onSmile()` function will not be called until the user smiles "harder".

The threshold for each gesture has been set to a default value. You may find that you want to increase or decrease these. You can do so setting the threshold on the `FaceTrigger` object prior to calling `.start()`.

For example, to require the user to smile very hard before the `onSmile()` function will be called, increase the `smileThreshold` attribute to 0.99 (up from the default value of 0.8).

```swift
faceTrigger = FaceTrigger(hostView: previewContainer, delegate: self)
faceTrigger?.smileThreshold = 0.99
faceTrigger?.start()
```

The default threshold values for each gesture can be found in `FaceTrigger.swift`.

```swift
public var smileThreshold: Float = 0.7
public var blinkThreshold: Float = 0.8
public var browDownThreshold: Float = 0.25
public var browUpThreshold: Float = 0.95
public var mouthPuckerThreshold: Float = 0.7
public var squintThreshold: Float = 0.8
```

### Hide Preview

Set the `hidePreview` to `true` if you application does not need to show the video stream of the user's face. Your application will still watch the user's face and your `FaceTriggerDelegate` will still receive calls when a gesture is performed even if the the video stream is not shown to the user.

```swift
faceTrigger = FaceTrigger(hostView: previewContainer, delegate: self)
faceTrigger?.hidePreview = true
faceTrigger?.start()
```

# License

The MIT License (MIT)

Copyright (c) 2017 Michael Peterson [Blinkloop](http://blinkloop.com)
