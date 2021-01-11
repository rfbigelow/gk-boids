//
//  SeekComponent.swift
//  Boids
//
//  Created by Robert Bigelow on 1/10/21.
//  Copyright © 2021 Robert Bigelow. All rights reserved.
//

import GameplayKit

class SeekComponent: GKComponent {
  var agent: GKAgent2D?
  var target: GKAgent2D
  var seekBehavior: GKBehavior
  var compositeBehavior: GKCompositeBehavior?

  init(target: GKAgent2D, behavior: GKBehavior) {
    self.target = target
    self.seekBehavior = behavior
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func didAddToEntity() {
    agent = entity?.component(ofType: GKAgent2D.self)
    compositeBehavior = agent?.behavior as? GKCompositeBehavior
  }
  
  override func willRemoveFromEntity() {
    agent = nil
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    guard let agent = agent,
          let compositeBehavior = compositeBehavior else {
      return
    }
    
    let distanceToTarget = distance(agent.position, target.position)
    let weight = min(max(0.0, distanceToTarget - 1000.0), 0.5)
    compositeBehavior.setWeight(weight, for: seekBehavior)
  }
}
