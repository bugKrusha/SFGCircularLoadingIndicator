//
//  CircularAnimation.swift
//  SFGCircularLoadingIndicator
//
//  Created by Jon-Tait Beason on 3/21/20.
//  Copyright © 2020 Jon-Tait Beason. All rights reserved.
//

import UIKit

enum AOSAnimationKeyPath: String {
  case position
  case rotation
}

final class CircularAnimationBuilder {
  func buildRotationAnimation() -> CABasicAnimation {
    let rotation = CABasicAnimation(keyPath: "transform.\(AOSAnimationKeyPath.rotation.rawValue)")
    rotation.duration = 1.5
    rotation.fromValue = 0
    rotation.toValue = CGFloat.pi * 2
    rotation.repeatCount = .infinity
    rotation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    
    return rotation
  }
  
  func buildCotailAnimation() -> CAAnimationGroup {
    // Do a full revolution
    let rotation = CABasicAnimation(keyPath: "transform.\(AOSAnimationKeyPath.rotation.rawValue)")
    rotation.fromValue = 0
    rotation.toValue = CGFloat.pi * 2
     
    // Go from opaque to fully transparent
    let dissolve = CABasicAnimation(keyPath: "opacity")
    dissolve.fromValue = 1.0
    dissolve.toValue = 0.0

    let groupAnimation = CAAnimationGroup()
    groupAnimation.animations = [dissolve, rotation]
    groupAnimation.duration = 1.5 // If you don't set, it won't work
    groupAnimation.repeatCount = .infinity
    groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
    
    return groupAnimation
  }
}
