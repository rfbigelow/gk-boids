# gk-boids
Boids implemented with GamePlayKit behaviors and SpriteKit

# Overview

This project utilizes GKAgent from GamePlayKit to run a naive implementation of Craig Reynolds' Boids. In addition to flocking behavior, each boid has a seek behavior that is controlled by the last touch point, and an avoid behavior to try and avoid other boids that are not in a boid's flock.

The seek behavior tends to dominate, so its weight is diminished the closer the boid gets to its goal. This lets us observe the flocking behavior around the goal, and has the boids turn around when they get too far away.

# Controls

Tap - Sets the goal at the point where the user tapped.
Pinch - Zooms the camera in or out. The scale factor is applied to the camera, so scaling up will zoom out (increasing the field of view) and scaling down will zoom in (decreasing the field of view.)

# Game Loop

This demo uses the ECS included in GamePlayKit. For simplicity, it just loops through the entities and calls their update() rather than using component systems.

# Notes

1. The flocking behavior is achieved by combining 2 GKGoal objects in a single GKBehavior. It is important to note that you only need to create one such behavior for all of the boids. You then add this common GKBehavior to each boid entity.
2. To achieve the dynamic scaling of the seek behavior, we use a custom component: SeekComponent. This component takes a GKAgent2D for the seek target, and a behavior. Once added to a boid entity, it will calculate the distance between the boid and the target. If the boid is within a (hard-coded) threshold then the seek behavior's weight is clamped to 0. As the distance exceeds the threshold the seek behavior's weight quickly returns to 0.5.
