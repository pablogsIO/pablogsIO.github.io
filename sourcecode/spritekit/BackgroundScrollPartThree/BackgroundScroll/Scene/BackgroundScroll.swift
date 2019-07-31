//
//  BackgroundScroll.swift
//  BackgroundScroll
//
//  Created by Pablo on 24/04/2019.
//  Copyright © 2019 Pablo Garcia. All rights reserved.
//

import SpriteKit

enum Implementation {
    case actions
    case linkedlist
}

public enum Direction {
    case right
    case left
}

class BackgroundScroll {

    private let backgrounds: [SKSpriteNode]
    private var linkedBackgrounds = LinkedList<SKSpriteNode>()

    private(set) var direction = Direction.right

    private unowned let scene: SKScene

    private(set) var speed: CGFloat = 0
    private let speedLimit: CGFloat = 100

    private var totalWidth: CGFloat = 0
    private(set) var fakeScreenBoundRight: CGFloat = 0
    private var fakeScreenBoundLeft: CGFloat = 0

    init?(sprites: [SKSpriteNode], scene: SKScene, implementation: Implementation) {
        guard sprites.count > 1 else {
            print("You have to include at least two backgrounds")
            return nil
        }
        self.scene = scene
        self.backgrounds = sprites

        self.fakeScreenBoundLeft = self.scene.frame.width/2
        self.fakeScreenBoundRight = fakeScreenBoundLeft+sprites[0].frame.width*3

        switch implementation {
        case .actions:
            addBackgroundsToSceneAndCalculateTotalWidth()
        case .linkedlist:
            createLinkedList()
        }
    }

    public func changeDirection() {
        self.direction = direction == .right ? .left: .right
        if direction == .left {
            while spriteIsOutOfBounds(sprite: linkedBackgrounds.last!.value) {
                let oldSprite = linkedBackgrounds.remove(node: linkedBackgrounds.last!)
                linkedBackgrounds.appendInit(value: oldSprite)
            }
        }
    }

    private func addBackgroundsToSceneAndCalculateTotalWidth() {

        for background in backgrounds {
            self.scene.addChild(background)
            totalWidth+=background.frame.width
        }
    }

    private func createLinkedList() {
        var offset: CGFloat = 0
        for sprite in backgrounds {
            sprite.position = CGPoint(x: fakeScreenBoundLeft+offset+sprite.frame.width/2, y: self.scene.frame.height/2)
            linkedBackgrounds.append(value: sprite)
            self.scene.addChild(sprite)
            offset += sprite.size.width
        }
    }

    public func scrollRight() {
        var offset: CGFloat = 0
        var spaceToBeOutsideScene: CGFloat = 0

        for node in backgrounds {
            spaceToBeOutsideScene += node.frame.width
            node.position = CGPoint(x: fakeScreenBoundRight+offset+node.frame.width/2, y: self.scene.frame.height/2)
            let actionMoveOutsideScene = SKAction.moveTo(x: fakeScreenBoundLeft-node.frame.width/2,
                                                         duration: TimeInterval(spaceToBeOutsideScene/speed))
            let actionMoveRightToLeft = SKAction.moveTo(x: fakeScreenBoundLeft-node.frame.width/2,
                                                        duration: TimeInterval((totalWidth)/speed))
            let actionMoveToLastPosition = SKAction.moveTo(x: fakeScreenBoundLeft+totalWidth-node.frame.width/2, duration: 0)
            offset += node.size.width
            node.run(SKAction.sequence([actionMoveOutsideScene, SKAction.repeatForever(SKAction.sequence([actionMoveToLastPosition, actionMoveRightToLeft]))]))
        }
    }

    public func update(deltaTime: TimeInterval, increaseVelocity: Bool) {

        guard !linkedBackgrounds.isEmpty else {
            return
        }
        self.updateSpeed(haveToIncreaseSpeed: increaseVelocity)
        if direction == .right {
            if let head = linkedBackgrounds.first {
                let headSprite = head.value
                headSprite.position = CGPoint(x: headSprite.position.x-CGFloat(deltaTime)*speed, y: headSprite.position.y)
                var node = linkedBackgrounds.first
                while node?.next != nil {
                    let previous = node
                    node = node?.next
                    node?.value.position = CGPoint(x: (previous?.value.position.x)!+(previous?.value.frame.width)!,
                                                   y: (previous?.value.position.y)!)
                }
                if spriteIsOutOfBounds(sprite: head.value) {
                    let node = linkedBackgrounds.remove(node: head)
                    linkedBackgrounds.append(value: node)
                }
            }
        } else {
            if let tail = linkedBackgrounds.last {
                let tailSprite = tail.value
                tailSprite.position = CGPoint(x: tailSprite.position.x+CGFloat(deltaTime)*speed, y: tailSprite.position.y)
                var node = linkedBackgrounds.last
                while node?.previous != nil {
                    let next = node
                    node = node?.previous
                    node?.value.position = CGPoint(x: (next?.value.position.x)!-(node?.value.frame.width)!,
                                                   y: (next?.value.position.y)!)
                }
                if spriteIsOutOfBounds(sprite: tail.value) {
                    let node = linkedBackgrounds.remove(node: tail)
                    linkedBackgrounds.appendInit(value: node)
                }
            }
        }
    }

    private func updateSpeed(haveToIncreaseSpeed: Bool) {
        let incrementFactor: CGFloat = 0.5
        self.speed = haveToIncreaseSpeed ? speed+incrementFactor: speed-incrementFactor

        if speed < 0 {
            speed = 0
        } else if speed > self.speedLimit {
            speed = self.speedLimit
        }
        print("speed: \(speed)")
    }
    private func spriteIsOutOfBounds(sprite: SKSpriteNode) -> Bool {

        let bound = direction == .right ? fakeScreenBoundLeft:fakeScreenBoundRight
        let xPosition = direction == .right ? (sprite.position.x+sprite.frame.width/2):(sprite.position.x-sprite.frame.width/2)
        let outOfBounds = direction == .right ? xPosition<bound: xPosition>bound

        return outOfBounds
    }
}
