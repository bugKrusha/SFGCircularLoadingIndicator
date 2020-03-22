//
//  CircularAnimationViewController.swift
//  SFGCircularLoadingIndicator
//
//  Created by Jon-Tait Beason on 3/21/20.
//  Copyright © 2020 Jon-Tait Beason. All rights reserved.
//

import UIKit

class CircularAnimationViewController: UIViewController {
  private let lightBlue = UIColor(red: 0.83, green: 0.92, blue: 0.97, alpha: 1.00)
  private let darkBlue = UIColor(red: 0.02, green: 0.56, blue: 0.83, alpha: 1.00)

  @IBOutlet weak var animationView: UIView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Make view look circular
    animationView.layer.cornerRadius = animationView.frame.width / 2
    let animationBuilder = CircularAnimationBuilder()
    let layerBuilder = AnimationLayerBuilder(frame: animationView.bounds, progress: 0.75)
    let layers = layerBuilder.buildLayers(majorColor: darkBlue, cotailColor: lightBlue)
    layers.cotail.add(animationBuilder.buildCotailAnimation(), forKey: "cotail-ting")
    layers.major.add(animationBuilder.buildRotationAnimation(), forKey: "spin-yo")
    
    animationView.layer.addSublayer(layers.cotail)
    animationView.layer.addSublayer(layers.major)
  }
}
