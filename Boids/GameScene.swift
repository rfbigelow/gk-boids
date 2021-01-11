//
//  GameScene.swift
//  Boids
//
//  Created by Robert Bigelow on 7/6/20.
//  Copyright © 2020 Robert Bigelow. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  var entities = [GKEntity]()
  var graphs = [String : GKGraph]()
  var touchAgent = GKAgent2D()
  
  private var lastUpdateTime : TimeInterval = 0
  
  override func sceneDidLoad() {
    self.lastUpdateTime = 0
    
    let camera = SKCameraNode()
    self.camera = camera
    addChild(camera)
    
    let rng = GKARC4RandomSource()
    for _ in 0..<200 {
      let (boidEntity, boid) = makeBoid(touchAgent: touchAgent)
      let xRand = CGFloat(rng.nextUniform())
      let yRand = CGFloat(rng.nextUniform())
      let x = (frame.maxX - frame.minX) * xRand
      let y = (frame.maxY - frame.minY) * yRand
      boid.position = CGPoint(x: x, y: y)
      self.entities.append(boidEntity)
      self.addChild(boid)
    }
    
    let boidAgents = Array(self.entities.compactMap { entity in entity.component(ofType: GKAgent2D.self) })
    let separateGoal = GKGoal(toSeparateFrom: boidAgents, maxDistance: 50.0, maxAngle: .pi / 2.0)
    let cohereGoal = GKGoal(toCohereWith: boidAgents, maxDistance: 100.0, maxAngle: .pi / 2.0)
    let alignGoal = GKGoal(toAlignWith: boidAgents, maxDistance: 100.0, maxAngle: .pi / 2.0)
    let flockBehavior = GKBehavior(goals: [separateGoal, cohereGoal, alignGoal])
    let avoidBehavior = GKBehavior(goal: GKGoal(toAvoid: boidAgents, maxPredictionTime: 0.5), weight: 1.0)
    for agent in boidAgents {
      if let behavior = agent.behavior {
        let behaviors: [GKBehavior] = [flockBehavior, behavior, avoidBehavior]
        let compositeBehavior = GKCompositeBehavior(behaviors: behaviors)
        compositeBehavior.setWeight(1.0, for: flockBehavior)
        compositeBehavior.setWeight(2.0, for: avoidBehavior)
        agent.behavior = compositeBehavior
        
        agent.entity?.addComponent(SeekComponent(target: touchAgent, behavior: behavior))
      }
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
        return
    }
    
    let location = touch.location(in: self)
    touchAgent.position = vector2(Float(location.x), Float(location.y))
  }
  
  override func update(_ currentTime: TimeInterval) {
    // Called before each frame is rendered
    
    // Initialize _lastUpdateTime if it has not already been
    if (self.lastUpdateTime == 0) {
        self.lastUpdateTime = currentTime
    }
    
    // Calculate time since last update
    let dt = currentTime - self.lastUpdateTime
    
    // Update entities
    for entity in self.entities {
        entity.update(deltaTime: dt)
    }
    
    self.lastUpdateTime = currentTime
  }
}

func makeBoid(touchAgent: GKAgent2D) -> (GKEntity, SKNode) {
  let triangle = CGMutablePath()
  triangle.addLines(between: [CGPoint(x: 0, y: -5), CGPoint(x: 15, y: 0), CGPoint(x: 0, y: 5), CGPoint(x: 0, y: -5)])
  
  let boid = SKShapeNode()
  boid.path = triangle
  
  let boidEntity = GKEntity()
  let boidSync = GKSKNodeComponent(node: boid)
  boidEntity.addComponent(boidSync)

  let seek = GKGoal(toSeekAgent: touchAgent)
  let seekBehavior = GKBehavior(goal: seek, weight: 1.0)
  let boidAgent = GKAgent2D()
  boidAgent.radius = 10.0
  boidAgent.maxSpeed = 200
  boidAgent.mass = 1.0
  boidAgent.maxAcceleration = 1000.0
  boidAgent.behavior = seekBehavior
  boidAgent.delegate = boidSync
  boidEntity.addComponent(boidAgent)
  
  return (boidEntity, boid)
}
