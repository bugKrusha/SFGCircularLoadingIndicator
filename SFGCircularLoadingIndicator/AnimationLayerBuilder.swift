//
//  AnimationLayerBuilder.swift
//  SFGCircularLoadingIndicator
//
//  Created by Jon-Tait Beason on 3/21/20.
//  Copyright © 2020 Jon-Tait Beason. All rights reserved.
//

import UIKit

final class AnimationLayerBuilder {
  // Radians
  private let majorStart: CGFloat
  private let majorEnd: CGFloat
  private let gap: CGFloat
  private let cotailMaxEnd: CGFloat
  
  // Steps over which the minor path is tapered
  private let taperSteps = 100
  
  // Animation progress
  private let progress: CGFloat = 0.75
  private let radius: CGFloat
  private let center: CGPoint
  private let lineWidth: CGFloat
  private let frame: CGRect
  
  init(frame: CGRect, progress: CGFloat) {
    func toRadians(degrees: CGFloat) -> CGFloat {
      degrees * .pi / 180
    }
    self.frame = frame
    
    // Make radius slightly smaller than the given frame
    self.radius = frame.width * 0.9 / 2
    self.center = CGPoint(x: frame.midX, y: frame.midY)
    self.lineWidth = frame.width / 25
    self.gap = toRadians(degrees: 30)
    self.majorStart = toRadians(degrees: 0.0)
    self.majorEnd = toRadians(degrees: 260)
    self.cotailMaxEnd = toRadians(degrees: 373)
  }
  
  func buildLayers(majorColor: UIColor, cotailColor: UIColor) -> (major: CALayer, cotail: CALayer){
    let majorPath = UIBezierPath(
      arcCenter: center,
      radius: radius,
      startAngle: majorStart,
      endAngle: majorEnd,
      clockwise: true
    )
    
    let majorLayer = buildLayer(color: majorColor, width: lineWidth, path: majorPath)
    majorLayer.frame = frame
    
    let cotailLayer = buildCotail()
    return (major: majorLayer, cotail: cotailLayer)
  }
  
  /// Build the white, tapering part of the animaition layer.
  private func buildCotail() -> CALayer {
    // Start from the end of major, adding the gap between
    // major and cotail
    let start = majorEnd + gap
    
    // 373 takes gets it just right because of the animation
    // progress. Max end is the absolute ending of the taper.
    let maxEnd = majorStart + cotailMaxEnd
    
    // The end will always be based on how much progress we made.
    let end = start + ((maxEnd - start) * progress)
    let stepAngleDelta = (end - start) / CGFloat(taperSteps)
    
    let layer = CALayer()
    layer.frame = frame
    return (1...taperSteps).reduce(into: (start: start, layer: layer)) { (data, step) in
      let endAngle = data.start + stepAngleDelta
      let path = UIBezierPath(
        arcCenter: center,
        radius: radius,
        startAngle: data.start,
        endAngle: endAngle,
        clockwise: true
      )
      let shapeLayer = buildLayer(
        color: .white,
        width: lineWidth * CGFloat(step) / CGFloat(taperSteps),
        path: path
      )
      data.layer.addSublayer(shapeLayer)
      data.start = endAngle
    }.layer
  }
  
  /// Helper function to build standardized layers.
  /// - Parameters:
  ///   - color: Background color
  ///   - width: Line width
  ///   - path: the backing path
  private func buildLayer(color: UIColor, width: CGFloat, path: UIBezierPath) -> CAShapeLayer {
    let shapeLayer = CAShapeLayer()
    shapeLayer.lineCap = .round
    shapeLayer.path = path.cgPath
    shapeLayer.lineWidth = width
    shapeLayer.fillColor = nil
    shapeLayer.strokeColor = color.cgColor
    
    return shapeLayer
  }
}
